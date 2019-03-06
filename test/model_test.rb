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
    @user = User.create!(name: "Adam Stark", email: "good@gmail.com", password: "qwer123456ty", gender: 0)
  end

  it "can create a user" do
    # @user = User.create!(name: "Adam Stark", gender: 0)
    # pp @user
    User.find(@user.id).name.must_equal "Adam Stark"
  end

  it "can update info" do
    @user.update_attribute(:name, "Jean Stock")
    User.find(@user.id).name.must_equal "Jean Stock"
  end

  it "can authenticate" do
    (User.authenticate("good@gmail.com", "qwer123456ty")).must_equal true
    (User.authenticate("good@gmail.com", "qwer123456t")).must_equal false
    (User.authenticate("bad@gmail.com", "qwer123456ty")).must_equal false
  end

  after do
    User.destroy_all
  end

end
