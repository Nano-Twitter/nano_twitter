require 'json'

@redis = Redis.new(host: 'nanotwitter.aouf4s.0001.use2.cache.amazonaws.com', port: 6379)

def redis
  @redis
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