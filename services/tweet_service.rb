require_relative '../model/tweet'

class TweetService

  def self.create_tweet(params)
    # Create a new tweet
    # param :parent_id; content;
    # return: an json response
    if params[:content] == '' && params[:parent_id] != '' # if it is a repost
      params[:content] = 'Repost' # add 'Repost' to the tweet content
    end
    if params[:content] == '' && !params[:parent_id] # the tweet has no content
      json_result(403, 7, "Your tweet should not be empty.")
    else # the tweet has content
      params[:parent_id] = BSON::ObjectId(params[:parent_id]) if params[:parent_id]
      params[:user_id] = BSON::ObjectId(params[:user_id])
      tweet = Tweet.new(params)

      if tweet.save
        # add to timeline
        tweet.write_attribute(:user_attr, {id: tweet[:user_id].to_s, name: get_single_user($redisStore, "user_#{tweet[:user_id].to_s}")['name']})
        push_single_tweet $redisStore, "timeline_#{params[:user_id]}", tweet.id.to_s
        json_result(201, 0, "Tweet sent successfully.", tweet)
      else
        json_result(403, 1, "Unable to send the tweet.")
      end

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
    tweet.write_attribute(:user_attr, {id: tweet[:user_id].to_s, name: get_single_user($redisStore, "user_#{tweet[:user_id].to_s}")['name']})
    if tweet
      json_result(200, 0, "Tweet found.", tweet)
    else
      json_result(403, 1, "Tweet not found")
    end
  end

  def self.get_tweets_by_user(params)
    # Get a list of tweets
    # params: user_id, start, count
    tweets = Tweet.where(user_id: BSON::ObjectId(params[:user_id])).order(created_at: :desc).skip(params[:start]).limit(params[:count])
    tweet_arr = Array.new
    if tweets
      tweets.each do |tweet|
        tweet_arr.push(tweet)
        tweet.write_attribute(:user_attr, {id: tweet[:user_id].to_s, name: get_single_user($redisStore, "user_#{tweet[:user_id].to_s}")['name']})
      end
      json_result(200, 0, "Tweets found.", tweet_arr)
    else
      json_result(403, 1, "Tweets not found.")
    end

  end

  def self.get_total_by_user(params)
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
    # Get a list of tweets of followees
    # params: user_id; start; count
    if cached? $redisStore, "timeline_#{params[:user_id]}"
      tweet_ids = get_timeline($redisStore, "timeline_#{params[:user_id]}")[params[:start], params[:start] + params[:count]]
      tweets = Tweet.find(tweet_ids)
      tweets.map {|tweet| tweet.write_attribute(:user_attr, {id: tweet[:user_id].to_s, name: get_single_user($redisStore, "user_#{tweet[:user_id].to_s}")['name']})}
      json_result(200, 0, "All tweets found.", tweets)
    else
      tweets = (User.find(BSON::ObjectId(params[:user_id])).following).map {|f| f.tweets}
      tweets = tweets.flatten(1)
      tweets.map {|tweet| tweet.write_attribute(:user_attr, {id: tweet[:user_id].to_s, name: get_single_user($redisStore, "user_#{tweet[:user_id].to_s}")['name']})}
      if tweets
        json_result(200, 0, "All tweets found.", tweets)
      else
        json_result(403, 1, "Tweets not found.")
      end
    end
  end

end
