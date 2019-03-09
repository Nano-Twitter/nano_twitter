require_relative '../model/tweet'

class TweetService

  def new_tweet(params, result)
    tweet = Tweet.new(params)
    if tweet.save
      result[:status] = 201
      result[:message] = "Tweet sent successfully."
    else
      result[:status] = 403
      result[:error] = "Fail to send the tweet."
    end
  end

  def delete_tweet(params, result)
    tweet = Tweet.find(params[:id])
    if tweet.delete
      result[:status] = 204
      result[:message] = "Tweet deleted successfully."
    else
      result[:status] = 400
      result[:error] = "Unable to delete the tweet."
    end
  end 

end