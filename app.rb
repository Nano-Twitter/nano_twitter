require 'sinatra'
require 'byebug'
require 'mongoid'
require 'json'
require_relative 'model/user.rb'
require_relative 'services/services'

# DB Setup
Mongoid.load! "config/mongoid.yml"

class App < Sinatra::Base

  configure do
    # enable :sessions    
    enable :cross_origin
    use Rack::Session::Cookie, :key => 'rack.session',
                           :path => '/',
                           :secret => 'your_secret'
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

  get '/*' do
    send_file File.join(settings.public_folder, 'index.html')
  end

  # Endpoints
  # sign up
  post '/api/users/signup' do
    user = User.new(params)
    if user.save
      status 201
      {message: "Signup success!"}.to_json
    else
      status 403
      {error: user.errors.to_json}.to_json
    end
  end

  # sign in
  post '/api/users/signin' do
    if User.authenticate(params[:email], params[:password])
      user = User.find_by_email(params[:email])
      session[:user] = user[:id].to_s
      {message: user.to_json}.to_json
    else
      status 403
      {error: "Username and password do not match!"}.to_json
    end

  end

  post '/api/users/auth' do
    res = session[:user] != nil && session[:user] == params[:_id][:$oid]
    {message: res.to_s}.to_json
  end

  delete '/api/users/signout' do 
    session[:user] = nil;
  end

end
