# require_relative '../app'
require 'mongoid'
require_relative '../model/user'
require_relative '../model/tweet'
require_relative '../seed/seed'

ENV['APP_ENV'] = 'test'

class TestService

  def self.destroy_all
    User.destroy_all
    Tweet.destroy_all
  end

  def self.seed_user(params=Null)
    if params[:users]
      Seed.create_test_user(params[:users])
      pp 'iiixx'
    else
      Seed.create_test_user
    end
  end
end


# TestService.seed_user