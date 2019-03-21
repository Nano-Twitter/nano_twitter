class Tweet
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic
  include Mongoid::Timestamps

  field :user_id, type: BSON::ObjectId
  field :content, type: String
  field :parent_id, type: BSON::ObjectId

  index({created_at: 1}, {unique: true})

  has_many :comments
  belongs_to :user, counter_cache: true
  has_and_belongs_to_many :hashtags, inverse_of: :tweets, counter_cache: true
end
