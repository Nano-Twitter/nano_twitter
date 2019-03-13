require_relative 'user_service.rb'
require_relative 'tweet_service.rb'
require_relative '../helper/service_helper.rb'

Mongoid.load! "config/mongoid.yml"

class Services
    attr_accessor :user_service
    def initialize
        @user_service = UserService.new
    end
end
