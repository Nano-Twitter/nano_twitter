require 'mongoid'
require 'json'
require_relative '../model/user.rb'
require_relative '../model/tweet.rb'
require_relative '../model/followee.rb'
require_relative '../model/follower.rb'
# DB Setup
Mongoid.load! "config/mongoid.yml", :test

follows = File.read('seed/follows.csv')
tweets = File.read('seed/tweets.csv')
users = File.read('seed/users.csv')

User.delete_all
Follower.delete_all
Followee.delete_all
Tweet.delete_all


user_hash = {}
users.split(/\n/).map {|x| x.split(',')}.each do |array|
  user_hash[array[0]] = User.create(name: array[1]).id
  puts array[1]
end


Tweet.create(tweets.split(/\n/).map {|x| x.split(',')}.map {|array| {content: array[1],user_id:user_hash[array[0]]}})

follows.split(/\n/).map {|x| x.split(',')}.map {|array| {follower:array[0],followee:array[1]}}

followers=follows.group_by{|x|user_hash[x[:followee]]}.map{|key,value|{user_id:key,followers:value}}

followees=follows.group_by{|x|user_hash[x[:follower]]}.map{|key,value|{user_id:key,followees:value}}

Followee.create(followees)

Follower.create(followers)