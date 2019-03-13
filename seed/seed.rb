require 'mongoid'
require 'json'
require_relative '../model/user.rb'
require_relative '../model/tweet.rb'
# DB Setup
Mongoid.load! "config/mongoid.yml", :test

follows = File.read('seed/follows.csv')
tweets = File.read('seed/tweets.csv')
users = File.read('seed/users.csv')

User.delete_all
Tweet.delete_all


user_hash = {}
users.split(/\n/).map {|x| x.split(',')}[1..10].each do |array|
  user_hash[array[0]] = User.create(name: array[1])
  puts array[0]
end
tweets.split(/\n/).shuffle[1..100].map {|x| x.split(',')}.map {|array| {content: array[1], user_id: user_hash[array[0]]}}.each do |x|
  puts Tweet.create x
end

follows = follows.split(/\n/).map {|x| x.split(',')}.map {|array| {follower: array[0], followee: array[1]}}

follows.group_by {|x| user_hash[x[:followee]]}
       .each do |user, follower_id|
  if user
    user.followers.push user_hash[follower_id]
  end
  puts user
end

