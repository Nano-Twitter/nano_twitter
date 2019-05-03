
require_relative '../helper/redis_helper.rb'
require_relative '../helper/rabbit_helper.rb'
require_relative '../helper/service_helper.rb'
require_relative 'user_service.rb'
require_relative 'tweet_service.rb'
require_relative 'follow_service.rb'
require_relative 'comment_service.rb'
require_relative 'test_service.rb'

def create_index
  User.create_indexes
  Comment.create_indexes
  Tweet.create_indexes
end
