# Example ufo/variables/development.rb
# More info on how variables work: http://ufoships.com/docs/variables/
@cpu = 512
@environment = helper.env_vars(%Q[
  RAILS_ENV=development
  SECRET_KEY_BASE=secret
  CLOUDAMQP_URL=amqp://user:wGLzrAvw8nvM@ec2-34-201-19-121.compute-1.amazonaws.com:5672
  REDIS_URL=redis://ntredis.aouf4s.ng.0001.use2.cache.amazonaws.com:6379
])
