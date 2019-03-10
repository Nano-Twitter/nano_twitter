require_relative '../model/user'

class UserService

  # json_result(status, code, message, data)

  def signup(params)
    user = User.new(params)
    if user.save
      # {status: 201, message: "Sign up success!"}.to_json
      json_result(201, 0, "Sign up success!")
    else
      # {status: 403, errors: user.errors.full_messages}.to_json
      json_result(403, 1, "Sign up failed")
    end
  end

  def login(params)
    if User.authenticate(params[:email], params[:password])
      user = User.find_by_email(params[:email]).unset(:password_hash)
      # {status: 200, message: "Login success!", payload: user.as_json}.to_json
      json_result(200, 0, "Login success!", user.as_json)
    else
      # {status: 403, errors: "Username and password do not match!"}.to_json
      json_result(403, 1, "Username and password do not match!")
    end
  end

  def get_profile(params)
    if params.has_key?(:id)
      user = User.find(params[:id])
    else
      # return {status: 403, message: 'Profile get failed', errors: ['Missing parameter user id']}.to_json
      return json_result(403, 1, 'Profile get failed')
    end

    if user
      user.unset(:password_hash)
      # {status: 200, payload: user.as_json}.to_json
      json_result(200, 0, 'Profile get success', user.as_json)
    else
      # {status: 403, errors: 'User not found'}.to_json
      json_result(403, 1, 'User not found')
    end
  end

  def update_profile(params)
    if params.has_key?(:id)
      user = User.find(params[:id])
    else
      # return {status: 403, message: 'Profile update failed', errors: ['Missing parameter user id']}.to_json
      return json_result(403, 1, 'Profile update failed')
    end

    if user
      begin
        user.update!(params)
        # {status: 200, message: 'Profile update succeed', payload: user.as_json}.to_json
        json_result(200, 0, 'Profile update succeed', user.as_json)
      rescue => e
        # {status: 403, message: 'Profile update failed', errors: e.message}.to_json
        json_result(403, 1, 'Profile update failed')
      end
    else
      # {status: 403, message: 'Profile update failed', errors: ['Invalid user id']}.to_json
      json_result(403, 1, 'Profile update failed')
    end
  end
end
