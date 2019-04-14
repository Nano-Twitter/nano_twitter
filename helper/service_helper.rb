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
  followers_ids = get_followers_ids(user_id)
  return if followers_ids.nil?
  followers_ids.each do |f_id|
    if $redisStore.cached?(f_id)
      $redisStore.push_single(f_id, tweet)
      if $redisStore.length(f_id)
        $redisStore.pop_single(f_id)
      end
    end
  end
end