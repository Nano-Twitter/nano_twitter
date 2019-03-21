class Comment
  include Mongoid::Document

  field :user_id, type: String
  field :tweet_id, type: String
  field :content, type: String

  belongs_to :tweet, counter_cache: true
  has_and_belongs_to_many :hashtags, counter_cache: true, inverse_of: :tweets

end
