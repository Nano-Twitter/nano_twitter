require_relative '../model/tweet'

class TweetService
  def new_tweet(params)
    tweet = Tweet.new(params)
    if tweet.save
      {status: 201, message: "Tweet sent success"}.to_json
    else
      {status: 403, message: "Fail to send the tweet"}.to_json
    end
  end
end