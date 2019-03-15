require 'mongoid'
require 'json'
require_relative '../model/user.rb'
require_relative '../model/tweet.rb'
# DB Setup
Mongoid.load! "config/mongoid.yml", :test

follows = File.read('seed/follows.csv')
tweets = File.read('seed/tweet.csv')
users = File.read('seed/user.csv')

User.delete_all
Tweet.delete_all


user_hash = {}
users.split(/\n/).map {|x| x.split(',')}.each do |array|
  user_hash[array[0]] = User.create(name: array[1])
  puts array[0].to_s
end

tweets.split(/\n/).shuffle[1..7000].map {|x| x.split(',')}.map {|array| {content: array[1], user_id: user_hash[array[0]]}}.each do |x|
  puts (Tweet.create x)
end

follows = follows.split(/\n/).map {|x| x.split(',')}.map {|array| {follower: array[0], followee: array[1]}}

follows.group_by {|x| user_hash[x[:followee]]}
    .each do |user, follower_ids|
  if user
    follower_ids.each {|follower_id| user.followers.push user_hash[follower_id]}
  end
  puts user
end

