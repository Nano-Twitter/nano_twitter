class Comment
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic
  field :user_id, type: String
  field :tweet_id, type: String
  field :content, type: String

  belongs_to :tweet, counter_cache: true


end
