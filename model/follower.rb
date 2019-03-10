class Follower
  include Mongoid::Document

  field :user_id, type: Integer
  field :followers, type: BSON::ObjectId
end
