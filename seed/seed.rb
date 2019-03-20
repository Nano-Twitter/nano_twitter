require 'json'
require 'mongoid'
require_relative '../model/user.rb'
require_relative '../model/tweet.rb'
require 'faker'
class Seed

  @users = File.read('./seed/users.csv')
  @follows = File.read('./seed/follows.csv')
  @tweets = File.read('./seed/tweets.csv')

  def self.reset
    User.destroy_all
    Tweet.destroy_all
  end

  def self.create_user(sum = 1000)
    @user_hash = {}
    User.collection.insert_many(@users.split(/\n/).lazy.take(sum).map {|x| x.split(',')}.map {|array| {name: array[1]}})
        .inserted_ids
        .each_with_index {|id, index| @user_hash[(index + 1).to_s] = id}
  end

  def self.create_user_and_related(sum = 1000)
    reset
    @user_hash = {}
    User.collection.insert_many(@users.split(/\n/).lazy.take(sum).map {|x| x.split(',')}.map {|array| {name: array[1]}})
        .inserted_ids
        .each_with_index do |id, index|
      key = (index + 1).to_s
      @user_hash[key] = id
    end
    Tweet.collection.insert_many(@tweets.split(/\n/).map {|x| x.split(',')}.select {|user_id, _content| @user_hash.key? user_id}
                                     .map {|array| {content: array[1], user_id: @user_hash[array[0]]}})

    follows = @follows.split(/\n/).lazy.map {|x| x.split(',')}
                  .select {|follower, followee| (@user_hash.key? follower) && (@user_hash.key? followee)}
    follows.group_by {|follower, followee| @user_hash[followee]}.each do |user, relation_ids|
      if user
        User.find(user).update_attribute(:follower_ids ,relation_ids.map {|follower_id, followee_id|  @user_hash[follower_id]})
      end
        puts User.find(user).following.size

    end
  end

  def self.create_tweet(user_id, sum = 7000)
    user_id = @user_hash[user_id.to_s]
    (1..sum).map {|x| Faker::TvShows::BojackHorseman.quote}.map {|x| {content: x, user_id: user_id}}.each do |x|
      puts (Tweet.create x)
    end
  end

end

