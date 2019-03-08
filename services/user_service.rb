require_relative '../app'
require_relative '../model/user'

class UserService
  def signup(params)
    user = User.new(params)
    if user.save
      {status: 201, message: "Sign up success!"}.to_json
    else
      {status: 403, errors: user.errors}.to_json
    end
  end

  def login(params)
    if User.authenticate(params[:email], params[:password])
      user = User.find_by_email(params[:email])
      user.remove_attribute(:password_hash)
      {status: 200, payload: user.to_json}.to_json
    else
      {status: 403, errors: "Username and password do not match!"}.to_json
    end
  end
end
