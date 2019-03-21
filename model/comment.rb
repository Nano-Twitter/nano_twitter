class Comment
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic
  field :user_id, type: String
  field :tweet_id, type: String
  field :content, type: String

  belongs_to :tweet, counter_cache: :comments_count
  has_and_belongs_to_many :hashtags, inverse_of: :tweets

end
