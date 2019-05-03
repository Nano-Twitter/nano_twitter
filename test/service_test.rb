ENV['APP_ENV'] = 'test'

require_relative '../app.rb'
require 'minitest/autorun'
require 'rack/test'
require_relative '../helper/rabbit_helper'
require_relative '../helper/redis_helper'

include Rack::Test::Methods

def app
  App
end

Mongoid.load! "config/mongoid.yml", :test

describe 'user_service' do

  before do
    Tweet.destroy_all
    User.destroy_all
    $redis.clear

    @user = User.create!(name: "Adam Stark", email: "good@gmail.com", password: "qwer123456ty", gender: 0)
    @user_id = @user.id.to_s

    follower = User.create!(name: "Follower", email: "follower@gmail.com", password: "qwer123456ty", gender: 0)

    params = {
        follower_id: @user_id,
        followee_id: follower.id.to_s

    }
    FollowService.follow(params)

    $redis.push_single_user @user_id, @user
    @service = UserService

  end

  it "can create a user" do
    params = {
        name: "Adam Stone",
        email: "bad@gmail.com",
        password: "qwer123456ty",
        gender: 1
    }
    response = @service.signup(params)
    response[:status].must_equal 201
    User.find_by(email: "bad@gmail.com").name.must_equal "Adam Stone"
  end

  it "can authenticate a user" do
    response = @service.login({
                                  email: "goo@gmail.com",
                                  password: "qwer123456ty"
                              })
    response[:status].must_equal 403

    response = @service.login({
                                  email: "good@gmail.com",
                                  password: "qwer123456ty"
                              })
    response[:status].must_equal 200
    response[:payload][:data]['name'].must_equal 'Adam Stark'
    response[:payload][:data].has_key?('password_hash').must_equal false
  end

  it "cannot create user with duplicate username" do
    params = {
        name: "Adam Stark",
        email: "g@gmail.com",
        password: "qwer123456ty",
        gender: 0
    }
    response = @service.signup(params)
    response[:status].must_equal 403
    response[:payload][:message].must_equal 'Signup failed!'
  end

  it "cannot create user with duplicate email" do
    params = {
        name: "Adam Stark1",
        email: "good@gmail.com",
        password: "qwe56ty",
        gender: 0
    }
    response = @service.signup(params)
    response[:status].must_equal 403
    response[:payload][:message].must_equal 'Signup failed!'
  end

  it 'can get user\'s profile' do
    params = {
        id: @user_id
    }
    response = @service.get_profile(params)
    response[:status].must_equal 200
    response[:payload][:data]['name'].must_equal 'Adam Stark'
  end

  it 'can update user\'s profile' do
    params = {
        id: @user_id,
        name: "Adam Starksss",
        email: "good@gmail.com",
        password: "qwdsadsadsadaeds",
        gender: 0,
    }
    response = @service.update_profile(params)
    response[:status].must_equal 200
  end

  it 'can do validation update user\'s profile' do
    params = {
        id: @user_id,
        name: "Adam Stark",
        email: "good@gmail.com",
        password: "qwsds",
        gender: 0,
    }
    response = @service.update_profile(params)
    response[:status].must_equal 403

    params = {
        id: @user_id,
        name: "Adam Stark",
        email: "good@gmail.com",
        password: "qwsdsadasds",
        gender: 0,
        unknown_param: 'xxxx'
    }
    response = @service.update_profile(params)
    response[:status].must_equal 200
  end

  it 'can recommend user' do
    response = @service.recommend(num: 3)
    response[:status].must_equal 200
  end

  after do
    Tweet.destroy_all
    User.destroy_all
    $redis.clear
  end

end

describe 'follow_service' do

  before do

    Tweet.destroy_all
    User.destroy_all
    $redis.clear

    @user = User.create!(name: "Adam Stark", email: "good@gmail.com", password: "qwer123456ty", gender: 0)
    @user_id = @user.id.to_s
    $redis.push_single_user @user_id, @user
    @follower = User.create!(name: "Follower", email: "follower@gmail.com", password: "qwer123456ty", gender: 0)
    @follower_id = @follower.id.to_s
    $redis.push_single_user @follower_id, @follower
    @service = FollowService

  end

  it 'can follow someone' do

    params = {
        follower_id: @follower_id,
        followee_id: @user_id
    }
    response = @service.follow(params)
    response[:status].must_equal 200
    response[:payload][:message].must_equal "Follow successfully"

  end

  it 'cannot follow a user twice' do

    params = {
        follower_id: @follower_id,
        followee_id: @user_id
    }

    response = @service.follow(params)
    response[:status].must_equal 200
    response[:payload][:message].must_equal "Follow successfully"

    response = @service.follow(params)
    response[:status].must_equal 403
    response[:payload][:message].must_equal "Fail to follow"

  end

  it 'can unfollow someone' do

    params = {
        follower_id: @follower_id,
        followee_id: @user_id
    }
    response = @service.follow(params)
    response[:status].must_equal 200
    response[:payload][:message].must_equal "Follow successfully"

    response = @service.unfollow(params)
    response[:status].must_equal 200
    response[:payload][:message].must_equal "Unfollow successfully"

  end

  after do
    Tweet.destroy_all
    User.destroy_all
    $redis.clear
  end

end

describe 'redis' do
  before do
    Tweet.destroy_all
    User.destroy_all
    $redis.clear
    @us = UserService
    @ts = TweetService
  end
  it 'can cache user' do
    params = {
        name: "Adam Stark",
        email: "g@gmail.com",
        password: "qwer123456ty",
        gender: 0
    }
    @us.signup(params)
    $redis.cached?("user_#{User.find_by(email: "g@gmail.com").id.to_s}").must_equal true
  end

  after do
    Tweet.destroy_all
    User.destroy_all
    $redis.clear
  end
end

describe 'tweet_service' do

  before do

    Tweet.destroy_all
    User.destroy_all
    $redis.clear
    @user = User.create!(name: "Adam Stark", email: "good@gmail.com", password: "qwer123456ty", gender: 0)
    # !!!IF NOT eliminate the hassword_hash, redis mapped_hmset will raise error because of different number of argument
    @user = User.without(:password_hash).find(@user.id)
    @user_id = @user.id.to_s
    $redis.push_single_user @user_id, @user
    @follower = User.create!(name: "Follower", email: "follower@gmail.com", password: "qwer123456ty", gender: 0)
    @follower_id = @follower.id.to_s
    $redis.push_single_user @follower_id, @follower
    @follower.follow! @user
    @tweet = Tweet.create!(user_id: @user_id, content: "This is the base tweet1.")
    @tweet_id = @tweet.id.to_s
    $redis.push_single_tweet "timeline_#{@user_id}", @tweet_id
    @tweet1 = Tweet.create!(user_id: @user_id, content: "This is the base tweet2.")
    @tweet_id1 = @tweet1.id.to_s
    $redis.push_single_tweet "timeline_#{@user_id}", @tweet_id1
    @tweet2 = Tweet.create!(user_id: @user_id, content: "This is the base tweet3.")
    @tweet_id2 = @tweet2.id.to_s
    $redis.push_single_tweet "timeline_#{@user_id}", @tweet_id2

    @service = TweetService

  end

  it 'can create a new tweet' do

    params = {
        user_id: @user_id,
        content: "I am a random tweet.",
    }
    response = @service.create_tweet(params)
    response[:status].must_equal 201
    response[:payload][:data]['content'].must_equal 'I am a random tweet.'

  end

  it 'can create a repo without entering content' do
    tweet_count = User.find(BSON::ObjectId(@user_id)).tweets_count
    params = {
        user_id: @user_id,
        content: nil,
        parent_id: @tweet_id,
    }
    response = @service.create_tweet(params)
    response[:status].must_equal 201
    response[:payload][:data]['content'].must_match /Retweet.*/
    response[:payload][:data]['parent_id'].to_s.must_equal @tweet_id

    after_tweet_count = User.find(response[:payload][:data]['user_id']).tweets_count
    after_tweet_count.must_equal tweet_count + 1
    a = Tweet.find(response[:payload][:data]['_id'])
  end

  it 'can retweet a retweet' do
    params = {
        user_id: @user_id,
        content: nil,
        parent_id: @tweet_id,
        root_id: @tweet_id
    }
    response = @service.create_tweet(params)
    response[:status].must_equal 201

    params_2 = {
        user_id: @user_id,
        parent_id: response[:payload][:data]['parent_id'],
        root_id: response[:payload][:data]['root_id'],
        content: nil
    }
    response_2 = @service.create_tweet(params_2)
    response[:status].must_equal 201


  end

  it 'can create a repo with a content' do

    params = {
        user_id: @user_id,
        content: "I am a repost",
        parent_id: @tweet_id
    }
    response = @service.create_tweet(params)
    response[:status].must_equal 201
    response[:payload][:data]['content'].must_match /I am a repost.*/
    response[:payload][:data]['parent_id'].to_s.must_equal @tweet_id

  end

  it 'can delete an existing tweet' do

    params = {
        tweet_id: @tweet_id
    }
    response = @service.delete_tweet(params)
    response[:status].must_equal 200
    response[:payload][:message].must_equal 'Tweet deleted successfully.'

  end

  it 'can get an existing tweet' do

    params = {
        tweet_id: @tweet_id
    }
    response = @service.get_tweet(params)
    response[:status].must_equal 200
    response[:payload][:message].must_equal 'Tweet found.'

  end

  it 'can get tweets by user' do

    params = {
        start: 0,
        count: 10,
        user_id: @user_id
    }
    response = @service.get_tweets_by_user(params)
    response[:status].must_equal 200
    response[:payload][:message].must_equal 'Tweets found.'
    response[:payload][:data].count.must_equal 3

  end

  it 'can get tweets of all followees' do

    params = {
        user_id: @follower_id,
        start: 0,
        count: 10,
    }
    response = @service.get_followee_tweets(params)
    response[:status].must_equal 200
    response[:payload][:message].must_equal 'All tweets found.'
    response[:payload][:data].count.must_equal 3

  end

  it 'can search' do
    create_index
    TweetService.search(page_num: 1, page_size: 10, content: 'wireless HTTP ')
  end

  after do
    Tweet.destroy_all
    User.destroy_all
    $redis.clear
  end

end