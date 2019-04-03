require_relative '../model/user'
require 'faker'

class UserService

  def self.signup(params)
    user = User.new(params)
    begin
      user.save!
      json_result(201, 0, "Signup success!")
    rescue => e
      json_result(403, 1, "Signup failed!")
    end
  end

  def self.login(params)
    if User.authenticate(params[:email], params[:password])
      user = User.without(:password_hash).find_by_email(params[:email])
      return json_result(200, 0, "Login success!", user)
    else
      return json_result(403, 1, "Username and password do not match!")
    end
  end

  def self.signout(params = {})
    json_result(200, 0, "Sign out success!")
  end

  def self.get_profile(params)
    if params.has_key?(:id)
      user = User.find(BSON::ObjectId(params[:id]))
    else
      return json_result(403, 1, 'Profile get failed')
    end

    if user
      user.unset(:password_hash)
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
      begin
        user.update!(params)
        json_result(200, 0, 'Profile update succeed', user)
      rescue => e
        json_result(403, 1, 'Profile update failed')
      end
    else
      json_result(403, 1, 'Profile update failed')
    end
  end


  def self.recommend(params)
    begin
      pp params[:num]
      user = params[:num].to_i.times.map {|i| User.create(name: Faker::Name.first_name, email: Faker::Internet.email, password_hash: Faker::Internet.password(12))}
      json_result(200, 0, 'Amway success', user)
    rescue
      json_result(403, 1, 'Amway failed')
    end
  end

end

UserService.recommend('')
