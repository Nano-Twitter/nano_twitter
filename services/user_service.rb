require_relative '../model/user'

class UserService

  # json_result(status, code, message, data)

  def self.signup(params)
    user = User.new(params)
    if user.save
      json_result(201, 0, "Sign up success!")
    else
      json_result(403, 1, "Sign up failed")
    end
  end

  def self.login(params)
    if User.authenticate(params[:email], params[:password])
      user = User.find_by_email(params[:email]).unset(:password_hash)
      json_result(200, 0, "Login success!", user)
    else
      json_result(403, 1, "Username and password do not match!")
    end
  end

  def self.get_profile(params)
    if params.has_key?(:id)
      user = User.find(params[:id])
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
      user = User.find(params[:id])
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
end
