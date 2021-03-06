require_relative '../model/user'
require 'faker'
require 'json'

class UserService

  def self.signup(params)
    user = User.new(params)
    if user.save
      user = User.without(:password_hash).find(user.id)
      $redis.push_single_user(user.id, user)
      json_result(201, 0, "Signup success!")
    else
      json_result(403, 1, "Signup failed!")
    end
  end

  def self.login(params)
    if User.authenticate(params[:email], params[:password])
      user = User.without(:password_hash).find_by_email(params[:email])
      $redis.push_single_user(user.id, user)
      return json_result(200, 0, "Login success!", user)
    else
      return json_result(403, 1, "Username and password do not match!")
    end
  end

  def self.imit_login(id)
    user = User.without(:password_hash).find(BSON::ObjectId(id))
    $redis.push_single_user(user.id, user)
  end

  def self.signout(params = {})
    json_result(200, 0, "Sign out success!")
  end

  def self.get_profile(params)

    if params.has_key?(:id)
      # user = $redis.get_single_user params[:id]
      user = User.without(:password_hash).find(BSON::ObjectId(params[:id])).as_json
      if user && user["follower_ids"]
        user["follower_ids"] = user["follower_ids"].map {|id| id.to_s}
      end
      if user && user["following_ids"]
        user["following_ids"] = user["following_ids"].map {|id| id.to_s}
      end
    else
      return json_result(403, 1, 'Profile get failed')
    end
    if user
      json_result(200, 0, 'Profile get success', user)
    else
      json_result(403, 1, 'User not found')
    end
  end

  def self.update_profile(params)

    if params.has_key?(:id)
      user = User.find(BSON::ObjectId(params[:id]))
    else
      return json_result(403, 1, 'Profile update failed')
    end

    if user
      if user.update(params)
        temp_user = User.without(:password_hash).find(BSON::ObjectId(params[:id]))
        $redis.push_single_user(params[:id], temp_user)
        json_result(200, 0, 'Profile update succeed', temp_user)
      else
        json_result(403, 1, 'Cannot update user info!')
      end
    else
      json_result(403, 1, 'Cannot find the user!')
    end

  end

  def self.recommend(params)
    begin
      user = params[:num].to_i.times.map {|i| User.create!(name: Faker::Name.first_name, email: Faker::Internet.email, password: Faker::Internet.password(12))}
      json_result(200, 0, 'Amway success', user)
    rescue => e
      json_result(403, 1, 'Amway failed')
    end
  end

end
