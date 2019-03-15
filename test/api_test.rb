ENV['APP_ENV'] = 'development'

require_relative '../app.rb'
require 'minitest/autorun'
require 'rack/test'

include Rack::Test::Methods

def app
  App
end

describe "users api" do

  before do
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
    post '/users/login', {
        email: "goo@gmail.com",
        password: "qwer123456ty"
    }
    last_response.ok?
    last_response.status.must_equal 403
    # JSON.parse()
    # JSON.parse(last_response.body)["error"].must_equal "Username and password do not match!"

    post '/users/login', {
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
    # JSON.parse(last_response.body)["error"].must_equal "Name Username already in use. Try another one!"
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
    # JSON.parse(last_response.body)["error"].must_equal "Email Email address already in use. Forget password?"
  end

  it 'can get user\'s profile' do
    get "/users/#{@user.id}"
    last_response.ok?
    last_response.status.must_equal 200
    JSON.parse(last_response.body)['data']['_id']['$oid'].must_equal @user.id.to_s
  end

  after do
    User.destroy_all
  end

end
