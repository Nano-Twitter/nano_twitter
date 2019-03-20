require 'json'
require 'mongoid'
require_relative '../model/user.rb'
require_relative '../model/tweet.rb'

class Seed

  @users = File.read('./seed/users.csv')
  @follows = File.read('./seed/follows.csv')
  @tweets = File.read('./seed/tweets.csv')

  def self.setup
    User.destroy_all
    Tweet.destroy_all

    create_test_user
    create_test_tweet
    create_test_follow
  end

  def self.create_user(sum = 1000)
    user_hash = {}
    @users.split(/\n/).take(sum).map {|x| x.split(',')}.each do |array|
      user_hash[array[0]] = User.create(name: array[1])
      puts array[1].to_s
    end
  end

  def self.create_user_and_related(sum = 1000)
    user_hash = {}
    @users.split(/\n/).take(sum).map {|x| x.split(',')}.each do |array|
      user_hash[array[0]] = User.create(name: array[1])
      puts array[1].to_s
    end

    follows = @follows.split(/\n/).take(sum).map {|x| x.split(',')}.map {|array| {follower: array[0], followee: array[1]}}


  end

  def self.create_tweet(sum = 7000)
    @tweets.split(/\n/).take(sum).map {|x| x.split(',')}.map {|array| {content: array[1], user_id: user_hash[array[0]]}}.each do |x|
      puts (Tweet.create x)
    end
  end

  def self.create_follow(sum = 5000)
    follows = @follows.split(/\n/).take(sum).map {|x| x.split(',')}.map {|array| {follower: array[0], followee: array[1]}}

    follows.group_by {|x| user_hash[x[:followee]]}.each do |user, follower_ids|
      if user
        follower_ids.each {|follower_id| user.followers.push user_hash[follower_id]}
      end
      puts user
    end
  end
end

