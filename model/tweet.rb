class Tweet
  include Mongoid::Document

  field :user_id, type: BSON::ObjectId
  field :content, type: String
  field :parent_id, type: BSON::ObjectId

  belongs_to :user
  
end
