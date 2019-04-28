require 'json'
require 'redis'
require 'connection_pool'


class RedisHelper

  def initialize(url = nil)
    if url
      @store = ConnectionPool::Wrapper.new(size: 20, timeout: 10) {Redis.new(url: url)}
    else
      @store = ConnectionPool::Wrapper.new(size: 20, timeout: 10) {Redis.new(host: 'localhost', port: 6379)}
      #@store = ConnectionPool::Wrapper.new(size: 20, timeout: 10) {Redis.new(url:'redis://h:p71bf5430796385942d036dfe722dedce0e9604841f8971ed7d3cf8e1840cb54a@ec2-3-213-0-112.compute-1.amazonaws.com:30129')}
    end
  end

  def get_client
    @store
  end

  # timeline
  # user_id: [tweet_id1, tweet_id2, ...]
  def push_mass_tweets(key, tweets)
    @store.lpush(key, tweets)
    #@store.expire(key, 120.hours.to_i)
  end

  def get_timeline(user_id, start, count)
    @store.lrange("timeline_#{user_id}", start, start + count - 1)
  end

  # this is currently identical to push mass_tweets, consider drop one of them
  # Todo
  def push_single_tweet(user_id, tweet)
    @store.lpush("timeline_#{user_id}", tweet)
    #@store.expire(key, 120.hours.to_i)
  end

  def push_single_tweet_if_exists(user_id, tweet)
    @store.lpushx("timeline_#{user_id}", tweet)
    #@store.expire(key, 120.hours.to_i)
  end

  # user info cache
  # user: user obj
  def push_single_user(user_id, user = User.without(:password_hash).find(BSON::ObjectId(user_id)))
    @store.hmset("user_#{user_id}", user.as_json.to_a.flatten(1))
    # cache the user name for mget operation
    # @store.set("un_#{user_id}",user.name)
    user
    #@store.expire("user_#{user_id}", 24.hours.to_i)
  end

  def get_single_user(user_id)
    user = @store.hgetall("user_#{user_id}")
    if user == {}
      user = push_single_user user_id
    end
    user
  end

  def incr_tweet_count(user_id)
    @store.hincrby("user_#{user_id}", 'tweets_count', 1)
  end

  def clear
    @store.flushall
  end

  # @deprecated
  def cached?(key)
    @store.exists(key)
  end
end

begin
  if Sinatra::Base.development? || Sinatra::Base.production?
    $redis = RedisHelper.new(ENV['REDIS_URL'])
  else
    $redis = RedisHelper.new
  end
  pp "Redis online :)"
rescue => e
  pp "Redis launch failed :("
  pp e
end
