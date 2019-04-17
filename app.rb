require 'json'
require 'byebug'
require 'sinatra'
require 'mongoid'
require_relative 'services/services'
require_relative 'helper/rabbit_helper'

# DB Setup
Mongoid.load! "config/mongoid.yml"

$rabbit_mq = RabbitServer.new
$rabbit_mq = ConnectionPool::Wrapper.new(size: 5, timeout: 3) { RabbitServer.new }
$rabbit_mq.subscribe('fanout')
pp "RabbitMQ Start"

# GET Success: 200
# POST Success: 201
# Fail: 403

class App < Sinatra::Base

  enable :sessions

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

    def curr_user
      session[:user]
    end

    def process_result
      status (@result[:status] || 500)
      (@result[:payload] || {}).to_json
    end
  end

  before do
    if (!session.key? (:user)) && (params.key? (:hack_user))
      session[:id] = params[:hack_user]
      session[:user] = User.find(session[:id])
    end
    session[:user] != nil ? @user = session[:user] : nil

    # $rabbit_mq = RabbitServer.new
    # pp '!!!!!!!hello'
    # $rabbit_mq.subscribe('fanout')
  end

  # # Endpoints

  # get '/' do
  #   ":)"
  # end
  # # Users

  # sign up： create a new user
  post '/users/signup' do
    @result = UserService.signup(params)
    process_result
  end


  # user authencation
  # sign in
  post '/users/signin' do
    @result = UserService.login(params)
    if @result[:status] == 200
      session[:user] = @result[:payload][:data]
      session[:id] = @result[:payload][:data]['_id']
    end
    process_result
  end

  # find a user's info
  get '/users/:id' do
    if params[:id] == ''
      params[:id] = session[:id]
    end
    @result = UserService.get_profile(params)
    process_result
  end


  # update a user's info
  put '/users/:id' do
    @result = UserService.update_profile(params)
    process_result
  end

  # sign out
  # better use post here
  delete '/users/signout' do
    session[:user] = nil
    @result = UserService.signout
    process_result
  end

  get '/users_recommend' do
    @result = UserService.recommend(params)
    process_result
  end

  # Follow

  # get all followee ids
  # not so useful?
  get '/followees/ids/:id' do
    if params[:id] == 'c'
      params[:id] = session[:id]
    end
  end

  # get all follower ids
  get '/followers/list/:id' do
    if params[:id] == 'c'
      params[:id] = session[:id]
    end
  end

  # get all followees
  get '/followees/list/:id' do
    if params[:id] == 'c'
      params[:id] = session[:id]
    end
  end

  # add follower
  post '/follows/:followee_id' do
    # params[:follower_id] = session[:id]
    params[:follower_id] = params[:user_id]
    @result = FollowService.follow(params)
    process_result
  end

  # unfollow
  delete '/follows/:followee_id' do
    # params[:follower_id] = session[:id]
    params[:follower_id] = params[:user_id]
    @result = FollowService.unfollow(params)
    process_result
  end

  # Tweets

  # get a user's timeline
  get '/tweets/users/:user_id' do
    @result = TweetService.get_tweets_by_user(params)
    process_result
  end

  # get personal homepage timeline
  get '/tweets/recent' do
    @result = TweetService.get_followee_tweets(params)
    process_result
  end

  # create a tweet
  post '/tweets' do
    @result = TweetService.create_tweet(params)
    process_result
  end

  # retrieve a tweet
  get '/tweeto/:id' do
    @result = TweetService.get_tweet(params)
    process_result
  end

  # delete a tweet
  delete '/tweets/:id' do
    @result = TweetService.delete_tweet(params)
    process_result
  end

  # get a user's timeline
  get '/tweets/users/:user_id' do
    @result = TweetService.get_tweets_by_user(params)
    process_result
  end

  # Tweet: Comment

  # count the number of comments
  # not so useful
  get '/tweets/:tweet_id/comments/count' do
    @result = CommentService.total_comment_by_tweet(params)
    process_result
  end

  # create a comment
  post '/tweets/:tweet_id/comments' do
    @result = CommentService.create_comment(params)
    process_result
  end

  # retrieve comments of a tweet
  get '/tweets/:tweet_id/comments' do
    @result = CommentService.get_comment_by_tweet(params)
    process_result
  end

  # delete a comment of a tweet
  delete '/tweets/:tweet_id/comments/:comment_id' do
    @result = CommentService.delete_comment(params)
    process_result
  end

  # Tweet: Like

  # count the number of likes
  get '/tweets/:tweet_id/likes/count' do
    @result = LikeService.total_likes_by_tweet(params)
    process_result
  end

  # create a like of a tweet (like)
  post '/tweets/:tweet_id/likes' do
    @result = LikeService.create_like(params)
    process_result
  end

  # delete a like of a tweet (unlike)
  delete '/tweets/:tweet_id/likes/:like_id' do
    @result = LikeService.delete_like(params)
    process_result
  end

  # Search (Blank for the moment)


  # # for protected routes
  #   get '/example_protected_route', :auth => :user do
  #     "I am protected"
  #   end


  # test interface


  # If needed deletes all users, tweets, follows
  # Recreates TestUser
  # Example: test/reset/all
  post '/test/reset/all' do
    @result = TestService.reset
    process_result
  end


  # Deletes all users, tweets and follows
  # Recreate TestUser
  # Imports data from standard seed data, see: Seed Data
  #   ?users=n means to import n users from the seed data…
  #   Including all the related follows (i.e. both users need to be present)
  #   And all the related tweets
  # Example: `/test/reset/standard?users=100&tweets=100
  post '/test/reset' do
    number = params[:users]
    @result = TestService.seed_user_and_related(number)
    process_result
  end


  # {u} can be the user id of some user, or the keyword testuser
  # n is how many randomly generated tweets are submitted on that users behalf
  post '/test/user/:id/tweets' do
    count = params[:count]
    user_id = params[:id]
    @result = TestService.seed_tweet user_id, count
    process_result
  end


  # One page “report”:
  #   How many users, follows, and tweets are there
  #   What is the TestUser’s id
  # Example: /test/status
  get '/test/status' do
    @result = TestService.status
    process_result
  end

  post '/create_index' do
    create_index
  end

  # following are route end point, will only be accessed when calling process_result in the previous route

  # get '/*' do
  #   if request.xhr?
  #     process_result
  #   else
  #     process_result
  #   end
  # end


  # post "/*" do
  #   process_result
  # end
  #
  # put "/*" do
  #   process_result
  # end
  #
  # delete "/*" do
  #   process_result
  # end

  get '/*' do
    send_file File.join(settings.public_dir, 'index.html')
  end
  run! if app_file == $0

end
