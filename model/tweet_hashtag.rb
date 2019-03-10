class TweetHashtag
  include Mongoid::Document

  field :tweet_id, type: String
  field :hashtag_id, type: String
end
