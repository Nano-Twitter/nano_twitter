require_relative '../model/tweet'

class TweetService
  def new_tweet(params)
    tweet = Tweet.new(params)
    if tweet.save
      {status: 201, message: "Tweet sent success"}
    end
  end
end