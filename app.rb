require 'sinatra'
require 'byebug'
require 'mongoid'
require 'json'
require_relative 'model/user.rb'
require_relative 'services/services'

# DB Setup
Mongoid.load! "config/mongoid.yml"

class App < Sinatra::Base

  enable :sessions

  register do
    def auth (type)
      condition do
        redirect '/login' unless send("is_#{type}?")
      end
    end
  end

  helpers do
    def is_user?
      @user != nil
    end

    def process_result
      status (@result[:status] || 500)
      (@result[:payload] || {}).to_json
    end
  end

  before do
    session[:user] != nil ? @user = User.find(session[:user]) : nil
  end

  # Endpoints
  # sign up
  post '/users/signup' do
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
  post '/users/signin' do
    if User.authenticate(params[:email], params[:password])
      user = User.find_by_email(params[:email])
      session[:user] = user[:id].to_s
      {message: user.to_json}.to_json
    else
      status 403
      {error: "Username and password do not match!"}.to_json
    end

  end

  # for protected routes 
  get '/example_protected_route', :auth => :user do
    "I am protected"
  end

  delete '/users/signout' do
    session[:user] = nil;
  end

  get '/shit' do
    @result = {shit: 1234}
    puts @result
    pass
  end

  get '/*' do
    unless request.xhr?
      pass
    end
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
