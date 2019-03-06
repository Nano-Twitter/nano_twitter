require_relative '../model/user'

class UserService
  def signup(params)
    user = User.new(params)
    if user.save
      {status: 201, message: "Signup success!"}.as_json
    else
      {status: 403, errors: user.errors}.as_json
    end
  end

  def login(params)
    if User.authenticate(params[:email], params[:password])
      {status: 200, payload: User.find_by_email(params[:email])}.as_json
    else
      {status: 403, errors: "Username and password do not match!"}.as_json
    end
  end
end