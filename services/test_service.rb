require_relative '../model/user'
require_relative '../model/tweet'
require_relative '../seed/seed'


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
    Seed.create_user_and_related number.to_i
    json_result(200, 0, "#{number.to_i} users created", {})
  end

  def self.seed_tweet(user_id, number)
    Seed.create_tweet user_id, number.to_i
    json_result(200, 0, "good", {})
  end

  def self.status
    json_result(200, 'cool', Seed.status)
  end

end
