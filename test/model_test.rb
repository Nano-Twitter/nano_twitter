ENV['APP_ENV'] = 'development'

require_relative '../app.rb'
require 'minitest/autorun'
require 'rack/test'

include Rack::Test::Methods

def app
  App
end

describe "user_model" do

  before do

    User.destroy_all
    @user = User.create!(name: "Adam Stark", email: "good@gmail.com", password: "qwer123456ty", gender: 0)
    @user2 = User.create!(name: "Bdam Stark", email: "bad@gmail.com", password: "qwer123456ty", gender: 0)
    @user3 = User.create!(name: "Cdam Stark", email: "no@gmail.com", password: "qwer123456ty", gender: 0)
  
  end

  it "can create a user" do
    User.find(@user.id).name.must_equal "Adam Stark"
  end

  it "can update info" do
    @user.update_attribute(:name, "Jean")
    User.find(@user.id).name.must_equal "Jean"
  end

  it "can update info without destroying password" do 
    (User.authenticate("good@gmail.com", "qwer123456ty")).must_equal true
    @user.update_attribute(:name, "Jean")
    (User.authenticate("good@gmail.com", "qwer123456ty")).must_equal true
  end

  it "can authenticate" do
    (User.authenticate("good@gmail.com", "qwer123456ty")).must_equal true
    (User.authenticate("good@gmail.com", "qwer123456t")).must_equal false
    (User.authenticate("badd@gmail.com", "qwer123456ty")).must_equal false
  end

  it 'can follow user' do
    @user.following.size.must_equal 0
    @user.follow!(@user2)
    @user.following.size.must_equal 1
    @user.following.first.name.must_equal 'Bdam Stark'

    @user.follow!(@user3)
    @user.following.size.must_equal 2
    @user.following.second.name.must_equal 'Cdam Stark'
  end

  it 'can unfollow user' do
    @user.following.size.must_equal 0
    @user.follow!(@user2)
    @user.follow!(@user3)
    @user.following.size.must_equal 2

    @user.unfollow!(@user2)
    @user.following.size.must_equal 1
  end

  it 'cannot follow a user twice' do
    @user.following.size.must_equal 0
    @user.follow!(@user2)
    @user.following.size.must_equal 1
    begin
      @user.follow!(@user2)
    rescue => e
      e.message.must_equal 'Duplicate following relationship.'
    end  
    @user.following.size.must_equal 1
  end

  it 'the effect of follow would also effect the followed use\'s follower number' do
    @user2.followers.size.must_equal 0

    @user.follow!(@user2)
    @user.following.size.must_equal 1
    @user.following.first.name.must_equal 'Bdam Stark'
    @user2.followers.size.must_equal 1
    @user2.followers.first.name.must_equal 'Adam Stark'

    @user.unfollow!(@user2)
    @user.following.size.must_equal 0
    @user2.following.size.must_equal 0
  end

  after do
    User.destroy_all
  end

end
