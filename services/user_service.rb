require_relative '../model/user'

class Service

  def signup(params)
    user = User.new(params)
    if user.save
      status 201
      {message: "Signup success!"}.to_json
    else
      halt 403, {errors: user.errors}.to_json
    end
  end

  def login(params)
    if User.authenticate(params[:email], params[:password])
      status 200
      User.find_by_email(params[:email]).to_json
    else
      halt 403, {errors: "Username and password do not match!"}.to_json
    end
  end

end