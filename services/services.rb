require_relative 'user_service.rb'

Mongoid.load! "config/mongoid.yml"

class Services
    attr_accessor :user_service
    def initialize
        @user_service = UserService.new
    end
end
