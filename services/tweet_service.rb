require_relative '../model/tweet'
require_relative '../helper/service_helper.rb'

class TweetService

  # json_result(status, code, message, data)

  def create_tweet(params)
    "" "
    Create a new tweet
    param params: a hashmap containing info of a new tweet
    return: an json response
    " ""
    if params[:content] == '' && params[:parent_id] != '' # if it is a repost
      params[:content] = 'Repost' # add 'Repost' to the tweet content
    end
    if params[:content] == '' # the tweet has no content
      json_result(403, 7, "Your tweet should not be empty.", {})
    else # the tweet has content
      tweet = Tweet.new(params)
      if tweet.save
        json_result(201, 0, "Tweet sent successfully.", tweet)
      else
        json_result(403, 1, "Unable to send the tweet.", {})
      end
    end
  end

  def delete_tweet(params)
    "" "
    Delete a tweet
    param params: a hashmap containing info of a tweet to delete
    return: an json response
    " ""
    tweet = Tweet.find(params[:id])
    if tweet.delete
      json_result(204, 0, "Tweet deleted successfully.", {})
    else
      json_result(400, 1, "Unable to delete the tweet.", {})
    end
  end

  def get_tweet(params)
    "" "
    Get a tweet
    param params: a hash containing the id of a tweet
    " ""
    tweet = Tweet.find(params[:id])
    if tweet
      json_result(201, 0, "Tweet found.", tweet)
    else
      json_result(400, 1, "Tweet not found", {})
    end
  end

  def get_tweets_by_user(params, start, count)
    "" "
    Get a list of tweets
    param params: a hash containing the user_id of the requested tweet
    " ""
    tweets = Tweet.where(user_id: params[:user_id]).order(created_at: :desc).skip(start).limit(count)
    if tweets
      json_result(201, 0, "Tweets found.", tweets)
    else
      json_result(201, 1, "Tweets not found.", {})
    end
  end

  def get_total_by_user(params)
    tweets = Tweet.where(user_id: params[:user_id]).count
  end

  def get_followee_tweets(params)
    tweets = User.where(user_id: params[:user_id]).includes(:tweets, from: :followee)
  end
end
