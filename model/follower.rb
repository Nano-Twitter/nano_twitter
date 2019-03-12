class Follower
  include Mongoid::Document

  field :user_id, type: String
  field :followers, type: BSON::ObjectId
end
