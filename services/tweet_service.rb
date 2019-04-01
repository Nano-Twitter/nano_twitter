require_relative '../model/tweet'
require_relative '../model/tweet_hashtag'

class TweetService

  def self.create_tweet(params)
    "" "
    Create a new tweet
    param params: a hashmap containing info of a new tweet
    return: an json response
    " ""
    if params[:content] == '' && params[:parent_id] != '' # if it is a repost
      params[:content] = 'Repost' # add 'Repost' to the tweet content
    end
    if params[:content] == '' # the tweet has no content
      json_result(403, 7, "Your tweet should not be empty.")
    else # the tweet has content
      params[:parent_id] = BSON::ObjectId(params[:parent_id]) if params[:parent_id]
      params[:user_id] = BSON::ObjectId(params[:user_id])
      tweet = Tweet.new(params)

      tweet.write_attribute(:user_attr, {id: tweet[:user_id], name: User.find(BSON::ObjectId(tweet[:user_id]))[:name]})

      if tweet.save
        json_result(201, 0, "Tweet sent successfully.", tweet)
      else
        json_result(403, 1, "Unable to send the tweet.")
      end
    end
  end

  def self.delete_tweet(params)
    "" "
    Delete a tweet
    param params: a hashmap containing info of a tweet to delete
    return: an json response
    " ""
    tweet = Tweet.find(BSON::ObjectId(params[:tweet_id]))
    if tweet.delete
      json_result(200, 0, "Tweet deleted successfully.")
    else
      json_result(403, 1, "Unable to delete the tweet.")
    end
  end

  def self.get_tweet(params)
    "" "
    Get a tweet
    param params: a hash containing the id of a tweet
    " ""
    tweet = Tweet.find(BSON::ObjectId(params[:tweet_id]))
    tweet.write_attribute(:user_attr, {id: tweet[:user_id], name: User.find(BSON::ObjectId(tweet[:user_id]))[:name]})

    if tweet
      json_result(200, 0, "Tweet found.", tweet)
    else
      json_result(403, 1, "Tweet not found")
    end
  end

  def self.get_tweets_by_user(params)
    "" "
    Get a list of tweets
    param params: a hash containing the user_id of the requested tweet
    " ""
    tweets = Tweet.where(user_id: BSON::ObjectId(params[:user_id])).order(created_at: :desc).skip(params[:start]).limit(params[:count])
    tweet_arr = Array.new
    tweets.each do |tweet|
      tweet_arr.push(tweet)
      tweet.write_attribute(:user_attr, {id: tweet[:user_id], name: User.find(BSON::ObjectId(tweet[:user_id]))[:name]})
    end

    if tweets
      json_result(200, 0, "Tweets found.", tweet_arr)
    else
      json_result(403, 1, "Tweets not found.")
    end
  end

  def self.get_total_by_user(params)
    "" "
    Get a the number of tweets of a user
    param params: a hash containing the user_id of the requested tweet
    " ""
    tweets = Tweet.where(user_id: BSON::ObjectId(params[:user_id])).count
    if tweets
      json_result(200, 0, "Tweets found.", tweets)
    else
      json_result(403, 1, "Tweets not found.")
    end
  end

  def self.get_followee_tweets(params)
    "" "
    Get a list of tweets of followees
    param params: a hash containing the user_id of the requested tweet
    " ""
    tweets = (User.find(BSON::ObjectId(params[:user_id])).following).map {|f| f.tweets}
    tweets = tweets.flatten(1)
    # following_ids = User.find(params[:user_id]).following_ids
    # tweets = Tweet.where(user_id: following_ids[0])
    # pp following_ids
    # pp tweets
    tweets.map {|tweet| tweet.write_attribute(:user_attr, {id: tweet[:user_id], name: User.find(BSON::ObjectId(tweet[:user_id]))[:name]})}
    if tweets
      json_result(200, 0, "All tweets found.", tweets)
    else
      json_result(403, 1, "Tweets not found.")
    end
  end

end
