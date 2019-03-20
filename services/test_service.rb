require_relative '../model/user'
require_relative '../model/tweet'
require_relative '../seed/seed'

ENV['APP_ENV'] = 'test'

class TestService

  def self.destroy_all
    User.destroy_all
    Tweet.destroy_all
  end

  def self.seed_user(params=nil)
    if params and params[:users]
      Seed.create_test_user(params[:users].to_i)
    else
      Seed.create_test_user
    end
  end

  def self.seed_tweet(params=nil)
    if params and params[:tweets]
      # Seed.
    end
  end
end
