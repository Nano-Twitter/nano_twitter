require 'redis'

@redis = Redis.new(host: 'nanotwitter.aouf4s.0001.use2.cache.amazonaws.com', port: 6379)

def redis
  @redis
end

require_relative '../helper/service_helper.rb'
require_relative 'user_service.rb'
require_relative 'tweet_service.rb'
require_relative 'follow_service.rb'
require_relative 'like_service.rb'
require_relative 'comment_service.rb'
require_relative 'test_service.rb'