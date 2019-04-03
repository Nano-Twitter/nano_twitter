class Like
  include Mongoid::Document

  field :user_id, type: String
  field :tweet_id, type: String

  belongs_to: tweet, counter_cache: true

end
