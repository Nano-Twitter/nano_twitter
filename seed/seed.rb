require 'mongoid'
require 'json'
require_relative '../model/user.rb'
require_relative '../model/tweet.rb'
require_relative '../model/followee.rb'
require_relative '../model/follower.rb'
# DB Setup
Mongoid.load! "../config/mongoid.yml", :test

follows = File.read('./follows.csv')
tweets = File.read('./tweets.csv')
users = File.read('./users.csv')

User.delete_all
Follower.delete_all
Followee.delete_all
Tweet.delete_all


user_hash = {}
users.split(/\n/).map {|x| x.split(',')}.each do |array|
  user_hash[array[0]] = User.create(name: array[1])
  puts array[0]
end


Tweet.create(tweets.split(/\n/).map {|x| x.split(',')}.map {|array| {content: array[1],user_id:user_hash[array[0]]}})

follow=follows.split(/\n/).map {|x| x.split(',')}.map {|array| {}}