class TweetHashtag
  include Mongoid::Document

  field :tweet_id, type: Integer
  field :hashtag_id, type: Integer
end
