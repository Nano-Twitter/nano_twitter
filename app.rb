require 'sinatra'
require 'byebug'
require 'mongoid'
require 'json'
# require_relative 'model/user.rb'
require_relative 'services/services'

# DB Setup
Mongoid.load! "config/mongoid.yml"

# GET Success: 200
# POST Success: 201
# Fail: 403

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
  # Users

  # sign up： create a new user
  post '/users/signup' do
    @result = UserService.signup(params)
    pass
  end

  # find a user's info
  get '/users/:id' do
    @result = UserService.get_profile(params)
    pass
  end

  # update a user's info
  put '/users/:id' do
    @result = UserService.update_profile(params)
    pass
  end

  # user authencation
  # sign in
  post '/users/login' do
    @result = UserService.login(params)
    if @result[:status] == 200
      session[:user] = @result[:payload][:data]
    end
    pass
  end

  # sign out
  delete '/users/signout' do
    session[:user] = nil;
  end

  # Follow

  # get all followee ids
  get '/followees/ids/:id' do
    
  end

  # get all follower ids
  get '/followers/list/:id' do
  end

  # get all followees
  get '/followees/list/:id' do
  end

  # get all followers
  put '/follows/:followee_id' do
    @result = FollowService.follow(params)
    pass
  end

  delete '/follows/:followee_id' do
    @result = FollowService.unfollow(params)
    pass
  end

# Tweets

  post '/tweets' do
    @result = TweetService.create_tweet(params)
    pass
  end

  get '/tweets/:id' do
    @result = TweetService.get_tweet(params)
    pass
  end

  delete '/tweets/:id' do
    @result = TweetService.delete_tweet(params)
    pass
  end

  get '/tweets/:id/comments' do

  end

  post '/tweets/:id/comments' do

  end

  post '/tweets/:id/like' do

  end

  delete '/tweets/:id/like' do

  end

  get '/tweets/recent' do
    @result = TweetService.get_followee_tweets(params)
    pass
  end

  get '/tweets/user/:user_id' do
    @result = TweetService.get_tweets_by_user(params)
    pass
  end

  # Search (left blank for the moment)


  
  # for protected routes 
  get '/example_protected_route', :auth => :user do
    "I am protected"
  end


  get '/*' do
    if request.xhr?
      process_result
    else
      pass
    end
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

  # test interface
  post '/test/reset/all' do

  end
  
  post '/test/reset?users=u' do

  end

  post '/test/user/{u}/tweets?count=n' do
    # delete all users, tweets and follows
    # recreate
    # example: /test/reset/standard?users=100&tweets=100
  end

  get '/test/status' do

  end

  run! if app_file == $0

end
