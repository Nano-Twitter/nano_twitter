require 'sinatra'
require 'byebug'
require 'mongoid'
require 'json'
require_relative '../services/services'

# DB Setup
Mongoid.load! "../config/mongoid.yml"

# GET Success: 200
# POST Success: 201
# Fail: 403

class App < Sinatra::Base
  # enable :sessions

  # register do
  #   def auth (type)
  #     condition do
  #       redirect '/login' unless send("is_#{type}?")
  #     end
  #   end
  # end

  helpers do
    def is_user?
      @user != nil
    end

    def process_result
      status (@result[:status] || 500)
      (@result[:payload] || {}).to_json
    end
  end

  post '/test/reset/all' do

  end

  # before do
  #   session[:user] != nil ? @user = User.find(session[:user]) : nil
  # end

  # Endpoints
  # sign up
  post '/users/signup' do
    @result = UserService.signup(params)
    pass
  end

  # sign in
  post '/users/login' do
    @result = UserService.login(params)
    pass
  end

  delete '/users/signout' do
    session[:user] = nil;
  end

  get '/users/:id' do
    @result = UserService.get_profile(params)
    pass
  end

  # for protected routes
  get '/example_protected_route', :auth => :user do
    "I am protected"
  end


  get '/*' do
    # unless request.xhr?
    #   pass
    # end
    process_result
  end

  post "/*" do
    process_result
  end

  put "/*" do
    process_result
  end

  delete "/*" do
    process_result
  end


  get '/*' do
    send_file File.join(settings.public_folder, 'index.html')
  end

  run! if app_file == $0

end

