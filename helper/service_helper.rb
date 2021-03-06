require 'json'
require_relative '../model/user'

def json_result(status, code, message, data = {})
  {
      status: status,
      payload: {
          code: code,
          message: message,
          data: data.as_json
      }
  }
end

def fanout_helper(user_id, tweet_id)
  user_id = BSON::ObjectId(user_id)
  tweet_id = BSON::ObjectId(tweet_id)

  $redis.push_single_tweet(user_id, tweet_id)

  followers_ids = get_followers_ids(user_id)
  return if followers_ids.nil?
  # todo batch insert
  followers_ids.each do |f_id|
    $redis.push_single_tweet_if_exists(f_id, tweet_id)
  end
end

def get_followers_ids(user_id)
  User.find(BSON::ObjectId(user_id)).follower_ids
end
