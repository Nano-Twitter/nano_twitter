require 'mongoid'
require 'json'
require_relative '../model/user.rb'
require_relative '../model/tweet.rb'
require_relative '../model/user.rb'

# DB Setup
Mongoid.load! "config/mongoid.yml", :test

follows=file.read('./follows.csv')
tweets=file.read('./tweets.csv')
users=file.read('./users.csv')