require 'json'
require 'redis'
require 'connection_pool'

# $redis = Redis.new(host: 'nanotwitter.aouf4s.0001.use2.cache.amazonaws.com', port: 6379)

# $redisStore = ConnectionPool::Wrapper.new(size: 5, timeout: 3) { Redis.new(host: 'ntredis.kloma7.0001.use1.cache.amazonaws.com', port: 6379) }

# begin
#   # $redisStore = ConnectionPool::Wrapper.new(size: 5, timeout: 3) {Redis.new(host: ENV['REDIS_URL'])}
#   $redisStore = Redis.new(url: ENV['REDIS_URL'])
# rescue
#   pp '!!!!!error in redis'
# #   $redisStore = ConnectionPool::Wrapper.new(size: 5, timeout: 3) {Redis.new(host: 'localhost', port: 6379)}
# end
class RedisHelper

  def initialize(host: '')
    @store = Redis.new(host: host, port: 6379)
  end

  def cached?(key)
    @store.exists(key)
  end
  
  # timeline
  # user_id: [tweet_id1, tweet_id2, ...]
  def push_mass_tweets(key, tweets)
    tweets.each do |t|
      @store.lpush(key, t)
      @store.expire(key, 24.hours.to_i)
    end
  end
  
  def get_timeline(key, start, count)
    @store.lrange(key, start, start + count - 1)
  end
  
  def push_single_tweet(key, tweet)
    @store.lpush(key, tweet)
    @store.expire(key, 120.hours.to_i)
  end
  
  # user info cache
  # user: user_info_json
  def push_single_user(key, user)
    @store.set(key, user.to_json)
    @store.expire(key, 24.hours.to_i)
  end
  
  def get_single_user(key)
    # JSON.parse(JSON.parse(store.get(key)))
    JSON.parse(@store.get(key))
  end
  
  def clear()
    @store.flushall
  end

end

$redis = RedisHelper.new(host: 'localhost')

