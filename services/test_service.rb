require_relative '../model/user'
require_relative '../model/tweet'
require_relative '../seed/seed'

ENV['APP_ENV'] = 'test'

class TestService

  def self.reset
    Seed.reset
    Seed.create_user
    json_result(200, 0, "good", {})
  end

  def self.destroy
    Seed.reset
    json_result(200, 0, "good", {})
  end

  def self.seed_user_and_related(number)
    Seed.reset
    Seed.create_user_and_related number
    json_result(200, 0, "good", {})
  end

  def self.seed_tweet(user_id, number)
    Seed.create_tweet user_id, number
    json_result(200, 0, "good", {})
  end


end
