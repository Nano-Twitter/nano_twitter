require_relative '../model/tweet'
require 'set'
class TweetService

  @name_cache = {}
  @name_cache_time_stamps = Time.now.to_i
  @name_cache_invalidate_time = 60 # expire in 1 minutes
  # method use to exprie name cache
  def self.check_and_expire_name_cache
    if Time.now.to_i - @name_cache_time_stamps > @name_cache_invalidate_time
      @name_cache = {}
      @name_cache_time_stamps = Time.now.to_i
    end
  end

  def self.find_user_name id
    if @name_cache.key? id
      @name_cache[id]
    else
      name = $redis.get_single_user(id)['name']
      @name_cache[id] = name
      name
    end
  end

  def self.create_tweet(params)
    # Create a new tweet
    # param parent_id; content, user_id, root_id;
    # return: a json response

    # upload file to the amazon s3

    if params[:content] == '' && !params[:parent_id] # the tweet has no content
      return json_result(403, 7, "Your tweet should not be empty.")
    end

    unless !params[:parent_id] # if it is a Retweet
      params[:parent_id] = BSON::ObjectId(params[:parent_id])
      parent_tweet = Tweet.find(params[:parent_id])

      # TODO: update enqueue
      parent_tweet.update_attributes!(retweet_count: parent_tweet.retweet_count + 1)
      root_id = parent_tweet.root_id || parent_tweet.id
      params[:root_id] = BSON::ObjectId(root_id)
      # if params[:root_id] != params[:parent_id]
      #   root_tweet = Tweet.find(params[:root_id])
      #   root_tweet.update_attributes!(retweet_count: root_tweet.retweet_count + 1)
      # end
      if !params[:content] || params[:content] == ""
        params[:content] = 'Retweet'
      end
      parent_user_name = $redis.get_single_user(parent_tweet.user_id)['name']
      params[:content] += "// @#{parent_user_name}: #{parent_tweet.content}"
    end

    params[:user_id] = BSON::ObjectId(params[:user_id])
    tweet = Tweet.new(params)
    if tweet.save
      # add to timeline
      tweet.write_attribute(:user_attr, {id: tweet[:user_id].to_s, name: $redis.get_single_user(tweet[:user_id])['name']}) # this will not affect db

      # send to rabbit for fanout
      $rabbit_mq.enqueue('fanout', {user_id: tweet[:user_id].to_s, tweet_id: tweet.id.to_s}.to_json)

      # update user's tweet_count
      $redis.incr_tweet_count(tweet[:user_id])

      json_result(201, 0, "Tweet sent successfully.", tweet)
    else
      json_result(403, 1, "Unable to send the tweet.")
    end
  end

  def self.delete_tweet(params)
    # Delete a tweet
    # param params: a hashmap containing info of a tweet to delete
    # return: an json response
    tweet = Tweet.find(BSON::ObjectId(params[:tweet_id]))
    if tweet.delete
      json_result(200, 0, "Tweet deleted successfully.")
    else
      json_result(403, 1, "Unable to delete the tweet.")
    end
  end

  def self.get_tweet(params)
    # Get a tweet
    # param params: a hash containing the id of a tweet
    tweet = Tweet.find(BSON::ObjectId(params[:tweet_id]))
    # tweet.write_attribute(:user_attr, {id: tweet[:user_id].to_s,
    #                                    name: $redis.get_single_user(tweet[:user_id])['name']})
    if tweet
      json_result(200, 0, "Tweet found.", tweet)
    else
      json_result(403, 1, "Tweet not found")
    end
  end

  def self.get_tweets_by_user(params)
    # Get a list of tweets
    # params: user_id, start, count
    # params[:start]
    start = params[:start] ? params[:start].to_i : 0
    count = params[:count] ? params[:count].to_i : 50
    tweets = Tweet.where(user_id: BSON::ObjectId(params[:user_id])).order(created_at: :desc).skip(start).limit(count)

    if tweets
      tweets = tweets.map do |tweet|
        user_id = tweet[:user_id].to_s
        tweet = tweet.as_json
        tweet[:user_attr] = {id: user_id, name: find_user_name(user_id)}
        tweet
      end
      json_result(200, 0, "Tweets found.", tweets)
    else
      json_result(403, 1, "Tweets not found.")
    end

  end

  def self.search(params)
    page_num = params[:page_num] || 1
    page_size = params[:page_size] || 10
    tweets = Tweet.where('$text': {'$search': params[:content]}).skip(page_num * page_size - page_size).limit(page_size).map do |tweet|
      user_id = tweet[:user_id].to_s
      tweet = tweet.as_json
      tweet[:user_attr] = {id: user_id, name: find_user_name(user_id)}
      tweet
    end
    if tweets
      json_result(200, 0, "Tweets found.", tweets)
    else
      json_result(403, 1, "Tweets not found.")
    end
  end

  def self.get_total_tweets_count_by_user(params)
    # Get a the number of tweets of a user
    # params: user_id
    tweets = Tweet.where(user_id: BSON::ObjectId(params[:user_id])).count
    if tweets
      json_result(200, 0, "Tweets found.", tweets)
    else
      json_result(403, 1, "Tweets not found.")
    end
  end

  def self.get_followee_tweets(params)
    check_and_expire_name_cache
    # Get a list of tweets of followees
    # params: user_id; start; count
    user_id = params[:user_id]
    start = params[:start] ? params[:start].to_i : 0
    count = params[:count] ? params[:count].to_i : 50

    tweet_ids = $redis.get_timeline user_id, start, count

    if tweet_ids && tweet_ids.length > 0
      # get tweet from redis
      tweets = Tweet.order(created_at: :desc).find(tweet_ids.map {|t| BSON::ObjectId(t)})

      tweets = tweets.map do |tweet|
        user_id = tweet[:user_id].to_s
        tweet = tweet.as_json
        tweet[:user_attr] = {id: user_id, name: find_user_name(user_id)}
        tweet
      end
      json_result(200, 0, "All tweets found.", tweets)
    else
      # here begins the transaction and CAS operation
      client_pool = $redis.get_client
      client_pool.with do |client|
        key = "timeline_key+#{user_id}"
        client.watch key
        lock = client.get key
        if lock
          client.unwatch
          puts 'others building'
          return json_result(200, 0, "Timelines are being built, please wait", [])
        end
        client.multi
        client.set key, 1 # lock the item
        client.expire(key, 5.minutes.to_i)

        lock_flag = client.exec # make sure if the lock is a success
        if lock_flag
          following_and_self = User.find(BSON::ObjectId(user_id)).following.map {|u| u.id} << BSON::ObjectId(user_id)
          tweets = Tweet.where(:user_id.in => following_and_self).order(created_at: :desc)
          if tweets.count > 0
            client.lpush("timeline_#{user_id}", tweets.map {|t| t.id.to_s})
            tweets = tweets.map do |tweet|
              user_id = tweet[:user_id].to_s
              tweet = tweet.as_json
              tweet[:user_attr] = {id: user_id, name: find_user_name(user_id)}
              tweet
            end

            client_pool.del key
            return json_result(200, 0, "All tweets found.", tweets[start, start + count])
          else
            client_pool.del key
            return json_result(403, 1, "Tweets not found.")
          end
        else
          puts 'lock taken by others'
          puts lock_flag
          return json_result(200, 0, "Timelines are being built, please wait", [])
        end
      end
    end
  end
end