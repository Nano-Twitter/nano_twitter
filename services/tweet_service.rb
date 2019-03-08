require_relative '../model/tweet'

class TweetService
  def new_tweet(params, result)
    tweet = Tweet.new(params)
    if tweet.save
      result[:status] = 201
      result[:message] = "Tweet sent success."
    else
      result[:status] = 403
      result[:message] = "Fail to send the tweet."
    end
  end

  def delete_tweet(params)
    tweet = Tweet.find(params[:id])
    if tweet.delete
      {}

  end 
end