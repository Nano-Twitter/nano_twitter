require_relative '../model/user'

class UserService
  def signup(params)
    user = User.new(params)
    if user.save
      {status: 201, message: "Sign up success!"}.to_json
    else
      {status: 403, errors: user.errors.full_messages}.to_json
    end
  end

  def login(params)
    if User.authenticate(params[:email], params[:password])
      user = User.find_by_email(params[:email]).unset(:password_hash)
      {status: 200, message: "Login success!", payload: user.as_json}.to_json
    else
      {status: 403, errors: "Username and password do not match!"}.to_json
    end
  end

  def get_profile(params)
    if params.has_key?(:id)
      user = User.find(params[:id])
    else
      return {status: 403, message: 'Profile get failed', errors: ['Missing parameter user id']}.to_json
    end

    if user
      user.unset(:password_hash)
      {status: 200, payload: user.as_json}.to_json
    else
      {status: 403, errors: 'User not found'}.to_json
    end
  end

  def update_profile(params)
    if params.has_key?(:id)
      user = User.find(params[:id])
    else
      return {status: 403, message: 'Profile update failed', errors: ['Missing parameter user id']}.to_json
    end

    if user
      begin
        user.update!(params)
        {status: 200, message: 'Profile update succeed', payload: user.as_json}.to_json
      rescue => e
        {status: 403, message: 'Profile update failed', errors: e.message}.to_json
        # {status: 403, message: 'Profile update failed', errors: user.errors.full_messages}.to_json
      end
    else
      {status: 403, message: 'Profile update failed', errors: ['Invalid user id']}.to_json
    end
  end
end
