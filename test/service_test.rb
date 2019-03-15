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
    JSON.parse(response['payload']['data'])['name'].must_equal 'Adam Stark'
    # JSON.parse(response)['payload']['password_hash'].must_equal null
  end

  it "cannot create user with duplicate username" do
    params = {
        name: "Adam Stark",
        email: "g@gmail.com",
        password: "qwer123456ty",
        gender: 0
    }
    response = @service.signup(params)
    JSON.parse(response)['status'].must_equal 403
    # JSON.parse(response)['errors'].first.must_equal 'Name is already taken'
  end

  it "cannot create user with duplicate email" do
    params = {
        name: "Adam Stark1",
        email: "good@gmail.com",
        password: "qwe56ty",
        gender: 0
    }
    response = @service.signup(params)
    JSON.parse(response)['status'].must_equal 403
    # JSON.parse(response)['errors'].first.must_equal 'Email is already taken'
  end

  it 'can get user\'s profile' do
    params = {
        id: @user_id,
    }
    response = @service.get_profile(params)
    JSON.parse(response)['status'].must_equal 200
    JSON.parse(JSON.parse(response)['payload']['data'])['name'].must_equal 'Adam Stark'
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
    JSON.parse(response)['status'].must_equal 200
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
    JSON.parse(response)['status'].must_equal 403

    params = {
        id: @user_id,
        name: "Adam Stark",
        email: "good@gmail.com",
        password: "qwsdsadasds",
        gender: 0,
        unknown_param: 'xxxx'
    }
    response = @service.update_profile(params)
    JSON.parse(response)['status'].must_equal 403
  end

  after do
    User.destroy_all
  end
end
