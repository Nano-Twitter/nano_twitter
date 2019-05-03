ENV['APP_ENV'] = 'test'
require_relative '../app.rb'
require 'minitest/autorun'
require 'rack/test'

include Rack::Test::Methods

def app
  App
end


def set_request_headers
  header 'HTTP_X_REQUESTED_WITH', 'XMLHttpRequest'
end

describe "users api" do

  before do
    User.destroy_all
    @user = User.create!(name: "Adam Stark", email: "good@gmail.com", password: "qwer123456ty", gender: 0)
  end

  it "can create a user" do
    post '/users/signup', {
        name: "Adam Stone",
        email: "bad@gmail.com",
        password: "qwer123456ty",
        gender: 1
    }
    last_response.ok?
    last_response.status.must_equal 201
    JSON.parse(last_response.body)['message'].must_equal "Signup success!"
    User.find_by(email: "bad@gmail.com").name.must_equal "Adam Stone"
  end

  it "can authenticate a user" do
    post '/users/signin', {
        email: "bad@gmail.com",
        password: "qwer123456ty"
    }
    last_response.ok?
    last_response.status.must_equal 403

    post '/users/signin', {
        email: "good@gmail.com",
        password: "qwer123456ty"
    }
    last_response.ok?
    last_response.status.must_equal 200
  end


  it "cannot create user with duplicate username" do
    post '/users/signup', {
        name: "Adam Stark",
        email: "g@gmail.com",
        password: "qwer123456ty",
        gender: 0
    }
    last_response.ok?
    last_response.status.must_equal 403
  end

  it "cannot create user with duplicate email" do
    post '/users/signup', {
        name: "Adam Stark1",
        email: "good@gmail.com",
        password: "qwer123456ty",
        gender: 0
    }
    last_response.ok?
    last_response.status.must_equal 403
  end

  it 'can get user\'s profile' do
    get "/users/#{@user.id}", nil, {'HTTP_X_REQUESTED_WITH' => 'XMLHttpRequest'}
    last_response.ok?
    last_response.status.must_equal 200
    JSON.parse(last_response.body)['data']['_id']['$oid'].must_equal @user.id.to_s
  end

end

describe 'test interface api' do

  it 'can reset all data and recreates users and seet tweet to the first one' do
    post '/test/reset/all'
    last_response.ok?
    post '/test/user/1/tweets?count=100'
    last_response.ok?
  end

  it 'can reset all data and recreates TestUser at given number' do
    post '/test/reset?users=100'
    last_response.ok?
  end

  it 'can get status' do
    get '/test/status'
    last_response.ok?
  end

end