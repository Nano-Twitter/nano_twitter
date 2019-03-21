class Tweet
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic
  field :user_id, type: BSON::ObjectId
  field :content, type: String
  field :parent_id, type: BSON::ObjectId

  belongs_to :user, counter_cache: :tweet_count
  
end
