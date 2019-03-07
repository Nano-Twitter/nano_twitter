require 'sinatra'
require 'byebug'
require 'mongoid'
require 'json'
require_relative 'model/user.rb'

# DB Setup
Mongoid.load! "config/mongoid.yml"

class App < Sinatra::Base

  # set :port, 8000
  # set :bind, '127.0.0.1'

  configure do
    enable :cross_origin
    enable :sessions
    set :sessions, :expire_after => 2592000
    set :session_store, Rack::Session::Pool
  end
  before do
    response.headers['Access-Control-Allow-Origin'] = '*'
  end
  
  # routes...
  options "*" do
    response.headers["Allow"] = "GET, PUT, POST, DELETE, OPTIONS"
    response.headers["Access-Control-Allow-Headers"] = "Authorization, Content-Type, Accept, X-User-Email, X-Auth-Token"
    response.headers["Access-Control-Allow-Origin"] = "*"
    200
  end

  get '/' do
    redirect 'index.html'
  end

  # Endpoints
  # sign up
  post '/api/user/signup' do
    user = User.new(params)
    if user.save
      status 201
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
      user = User.find_by_email(params[:email])
    else
      error 403, {error: "Username and password do not match!"}.to_json
    end
  end

  delete '/api/user/signout' do 
    session[:user] = nil;
  end

end
