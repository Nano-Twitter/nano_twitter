class Tweet
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic
  include Mongoid::Timestamps

  field :user_id, type: BSON::ObjectId
  field :content, type: String
  field :parent_id, type: BSON::ObjectId

  index({created_at: 1})
  index({content: 'text'})

  has_many :comments
  has_many :likes
  # has_and_belongs_to_many :hashtags, inverse_of: :tweets

end
