require 'sinatra'
require 'byebug'
require 'mongoid'
require 'json'
require_relative 'helper/auth_helper.rb'
require_relative 'model/user.rb'
require_relative 'services/services'

# DB Setup
Mongoid.load! "config/mongoid.yml"

class App < Sinatra::Base

  enable :sessions

  before do
    if not session[:user]
      halt 401, 'not logged in'
    end
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

  delete '/api/users/signout' do
    session[:user] = nil;
  end

  get '/' do
    #send_file File.join(settings.public_folder, 'index.html')
    redirect '/index.html'
  end


  delete '/api/users/signout' do
    session[:user] = nil;
  end

  after do
    result = session[:result]
    status (result['status'] || 500)
    result['payload']
  end

end
