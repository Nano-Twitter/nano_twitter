require 'sinatra'
require 'byebug'
require 'mongoid'
require 'json'
require_relative 'model/user.rb'

# DB Setup
Mongoid.load! "config/mongoid.yml"

class App < Sinatra::Base

  set :port, 8000
  set :bind, '127.0.0.1'

  get '/' do
    "Hello Sinatra!"
  end

  # Endpoints
  # sign up
  post '/api/user/signup' do
    user = User.new(params)
    if user.save
      {message: "Signup success!"}.to_json
    else
      status 403
      body user.errors.to_json
      # error 404, {error: user.errors.full_messages[0]}.to_json
    end
  end

  # sign in
  post '/api/user/signin' do
    if User.authenticate(params[:email], params[:password])
      User.find_by_email(params[:email]).to_json
    else
      error 404, {error: "Username and password do not match!"}.to_json
    end
  end

  run! if __FILE__ == $0

end
