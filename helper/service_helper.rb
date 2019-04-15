require 'json'

# @redis = Redis.new(host: 'nanotwitter.aouf4s.0001.use2.cache.amazonaws.com', port: 6379)

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

def fanout_helper(user_id, tweet)
  push_single_tweet $redisStore, "timeline_#{user_id}", tweet.id.to_s
  followers_ids = get_followers_ids(user_id)
  return if followers_ids.nil?
  followers_ids.each do |f_id|
    if cached?($redisStore, f_id)
      push_single_tweet $redisStore, "timeline_#{f_id}", tweet.id.to_s
    end
  end
end

def get_followers_ids(user_id)
  User.find(BSON::ObjectId(user_id)).follower_ids
end