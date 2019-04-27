require 'json'
require 'redis'
require 'connection_pool'


class RedisHelper

  def initialize(url = nil)
    if url
      @store = ConnectionPool::Wrapper.new(size: 20, timeout: 10) {Redis.new(url: url)}
    else
      @store = Redis.new(host: 'localhost', port: 6379)
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

  def get_timeline(key, start, count)
    @store.lrange(key, start, start + count - 1)
  end

  # this is currently identical to push mass_tweets, consider drop one of them
  #Todo
  def push_single_tweet(key, tweet)
    @store.lpush(key, tweet)
    #@store.expire(key, 120.hours.to_i)
  end

  def push_single_tweet_if_exists(key,tweet)
    @store.lpushx(key, tweet)
    #@store.expire(key, 120.hours.to_i)
  end

  # user info cache
  # user: user obj
  def push_single_user(user_id, user = User.without(:password_hash).find(BSON::ObjectId(user_id)))
    @store.hmset("user_#{user_id}", user.as_json.to_a.flatten(1))
    # cache the user name for mget operation
    @store.set("un_#{user_id}",user.name)
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

  def cached?(key)
    @store.exists(key)
  end
end

begin
  $redis = RedisHelper.new(ENV['REDIS_URL'])
  pp "Redis online :)"
rescue
  pp "Redis launch failed :("
end
