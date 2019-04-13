class Tweet
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic
  include Mongoid::Timestamps

  field :user_id, type: BSON::ObjectId
  field :content, type: String
  field :parent_id, type: BSON::ObjectId
  field :comments_count, type: Integer, default: 0
  field :likes_count, type: Integer, default: 0

  belongs_to :user, counter_cache: true

  index({created_at: 1})
  index({content: 'text'})

  has_many :comments
  has_many :likes

  

end
