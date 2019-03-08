ENV['APP_ENV'] = 'test'

# require_relative '../app.rb'
require_relative '../services/services.rb'
require 'minitest/autorun'
require 'rack/test'

include Rack::Test::Methods

def app
  App
end

describe 'user_service' do
  before do
    User.destroy_all
    @user = User.create!(name: "Adam Stark", email: "good@gmail.com", password: "qwer123456ty", gender: 0)
    @service = Services.new.user_service
  end

  it "can create a user" do
    params = {
        name: "Adam Stone",
        email: "bad@gmail.com",
        password: "qwer123456ty",
        gender: 1
    }

    response = @service.signup(params)
    JSON.parse(response)['status'].must_equal 201
    User.find_by(email: "bad@gmail.com").name.must_equal "Adam Stone"
  end

  it "can authenticate a user" do
    response = @service.login({
                                  email: "goo@gmail.com",
                                  password: "qwer123456ty"
                              })
    JSON.parse(response)['status'].must_equal 403

    response = @service.login({
                                  email: "good@gmail.com",
                                  password: "qwer123456ty"
                              })
    a = JSON.parse(response)['payload']
    JSON.parse(response)['status'].must_equal 200

  end
  #
  # it "cannot create user with duplicate username" do
  #   post 'api/user/signup', {
  #       name: "Adam Stark",
  #       email: "g@gmail.com",
  #       password: "qwer123456ty",
  #       gender: 0
  #   }
  #   last_response.ok?
  #   last_response.status.must_equal 404
  #   JSON.parse(last_response.body)["error"].must_equal "Name Username already in use. Try another one!"
  # end
  #
  # it "cannot create user with duplicate email" do
  #   post 'api/user/signup', {
  #       name: "Adam Stark1",
  #       email: "good@gmail.com",
  #       password: "qwer123456ty",
  #       gender: 0
  #   }
  #   last_response.ok?
  #   last_response.status.must_equal 404
  #   JSON.parse(last_response.body)["error"].must_equal "Email Email address already in use. Forget password?"
  # end

  after do
    User.destroy_all
  end
end
