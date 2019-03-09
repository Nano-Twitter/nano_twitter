require_relative '../model/tweet'
require_relative '../helper/service_helper.rb'

class TweetService

  # json_result(status, code, message, data)

  def create_tweet(params)
    """
    Create a new tweet
    param params: a hashmap containing info of a new tweet
    return: an json response
    """
    tweet = Tweet.new(params)
    if tweet.save
      json_result(201, 0, "Tweet sent successfully.", tweet)
    else
      json_result(403, 1, "Unable to send the tweet.", {})
    end
  end

  def delete_tweet(params)
    """
    Delete a tweet
    param params: a hashmap containing info of a tweet to delete
    return: an json response
    """
    tweet = Tweet.find(params[:id])
    if tweet.delete
      json_result(204, 0, "Tweet deleted successfully.", {})
    else
      json_result(400, 1, "Unable to delete the tweet.", {})
    end
  end 

  def get_tweet(params)
    """
    Get a tweet
    param params: a hashmap
    """
  end

  def get_tweets_by_user(params, start, count)
  end
end