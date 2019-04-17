require_relative 'seed/seed'
require 'mongoid'
require_relative  'services/services'
ENV['RACK_ENV'] = 'development'
Mongoid.load! "config/mongoid.yml"
#Seed.create_user_and_related 1000



#pp TweetService.search(page_num:1,page_size:10,content:'wireless HTTP ')