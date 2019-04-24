require 'json'

redis = RedisHelper.new(ENV['REDIS_URL'])

def redis()
  redis
end

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

  $redis.push_single_tweet("timeline_#{user_id}", tweet_id)
  followers_ids = get_followers_ids(user_id)
  return if followers_ids.nil?
  followers_ids.each do |f_id|
    if $redis.cached?(f_id)
      $redis.push_single_tweet("timeline_#{f_id}", tweet_id)
    end
  end
end

def get_followers_ids(user_id)
  User.find(BSON::ObjectId(user_id)).follower_ids
end
