require_relative 'user_service.rb'
require_relative '../helper/service_helper.rb'

class Services
    attr_accessor :user_service

    @user_service = UserService.new
end
