require 'json'
require 'mongoid'
require_relative '../model/user.rb'
require_relative '../model/tweet.rb'
# require_relative '../model/hashtag.rb'
require 'faker'
class Seed

  @users = File.read('./seed/users.csv')
  @follows = File.read('./seed/follows.csv')
  @tweets = File.read('./seed/tweets.csv')

  def self.reset
    Tweet.collection.delete_many(Tweet.all)
    User.collection.delete_many(User.all)
  end

  def self.create_user(sum = 100)
    @user_hash = {}
    User.collection
        .insert_many(@users.split(/\r\n|\n/).lazy.take(sum)
                         .map {|x| x.split(',')}
                         .map {|array| {name: array[1], email: "#{array[1]}@google.com"}})
        .inserted_ids
        .each_with_index {|id, index| @user_hash[(index + 1).to_s] = id}

  end

  def self.create_user_and_related(sum = 100)
    reset
    @user_hash = {}
    User.collection.
        insert_many(@users.split(/\r\n|\n/).lazy.take(sum)
                        .map {|x| x.split(',')}.map {|array| {name: array[1], email: "#{array[1]}@google.com"}})
        .inserted_ids
        .each_with_index do |id, index|
      key = (index + 1).to_s
      @user_hash[key] = id
    end
    Tweet
        .collection
        .insert_many(@tweets.split(/\r\n|\n/)
                                    .map {|x| x.split(',')}.select {|user_id, _content| @user_hash.key? user_id}
                                    .map {|array| {content: array[1],
                                                   created_at: Faker::Time.between(30.days.ago, Date.today, :all),
                                                   user_id: @user_hash[array[0]]}})

    follows = @follows.split(/\r\n|\n/).map {|x| x.split(',')}
                  .select {|follower, followee|
                    (@user_hash.key? follower) && (@user_hash.key? followee)}
    follows.group_by {|follower, followee| @user_hash[followee]}.each do |user, relation_ids|
      if user
        User.find(user).update_attribute(:follower_ids, relation_ids.map {|follower_id, followee_id| @user_hash[follower_id]})
      end

    end
  end

  def self.create_tweet(user_id, sum = 70)
    user_id = @user_hash[user_id.to_s]
    (1..sum).map {|x| Faker::TvShows::BojackHorseman.quote}
        .map {|x| {content: x,
                   created_at: Faker::Time.between(30.days.ago, Date.today, :all),
                   user_id: user_id}}.each do |x|
      Tweet.create x
    end
  end

  def self.status
    {users: User.count, tweets: Tweet.count, follows: User.all.map {|x| x.followers.size}.sum}
  end

end

