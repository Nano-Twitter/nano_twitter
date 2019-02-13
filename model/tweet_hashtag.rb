class TweetHashtag
  include Mongoid::Document
  field :id, type: Integer
  field :tweet_id, type: Integer
  field :hashtag_id, type: Integer
end
