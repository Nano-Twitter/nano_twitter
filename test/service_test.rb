ENV['APP_ENV'] = 'test'

require_relative '../app.rb'
require 'minitest/autorun'
require 'rack/test'

include Rack::Test::Methods

def app
  App
end

Mongoid.load! "config/mongoid.yml"

describe 'user_service' do
  before do
    User.destroy_all
    @user = User.create!(name: "Adam Stark", email: "good@gmail.com", password: "qwer123456ty", gender: 0)
    @user_id = @user.id
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
    response[:payload][:message].must_equal 'Sign up failed'
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
    response[:payload][:message].must_equal 'Sign up failed'
  end

  it 'can get user\'s profile' do
    params = {
        id: @user_id,
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
    response[:status].must_equal 403
  end

  after do
    User.destroy_all
  end

end

describe 'tweet_service' do 

  before do
    User.destroy_all
    Tweet.destroy_all
    @user = User.create!(name: "Adam Stark", email: "good@gmail.com", password: "qwer123456ty", gender: 0)
    @user_id = @user.id
    @follower = User.create!(name: "Follower", email: "follower@gmail.com", password: "qwer123456ty", gender: 0)
    @follower_id = @follower.id
    @tweet = Tweet.create!(user_id: @user_id, content: "This is the base tweet.")
    @tweet_id = @tweet.id
    @tweet1 = Tweet.create!(user_id: @user_id, content: "This is the base tweet.")
    @tweet_id1 = @tweet1.id
    @tweet2 = Tweet.create!(user_id: @user_id, content: "This is the base tweet.")
    @tweet_id2 = @tweet2.id
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
    params = {
      user_id: @user_id,
      content: "",
      parent_id: @tweet_id
    }
    response = @service.create_tweet(params)
    response[:status].must_equal 201
    response[:payload][:data]['content'].must_equal 'Repost'
    response[:payload][:data]['parent_id'].must_equal @tweet_id
  end

  it 'can create a repo with a content' do
    params = {
      user_id: @user_id,
      content: "I am a repost",
      parent_id: @tweet_id
    }
    response = @service.create_tweet(params)
    response[:status].must_equal 201
    response[:payload][:data]['content'].must_equal 'I am a repost'
    response[:payload][:data]['parent_id'].must_equal @tweet_id
  end

  it 'can delete an existing tweet' do
    params = {
      id: @tweet_id
    }
    response = @service.delete_tweet(params)
    response[:status].must_equal 200
    response[:payload][:message].must_equal 'Tweet deleted successfully.'
  end

  it 'can get an existing tweet' do
    params = {
      id: @tweet_id
    }
    response = @service.get_tweet(params)
    response[:status].must_equal 200
    response[:payload][:message].must_equal 'Tweet found.'
  end

  

end