class Followee
  include Mongoid::Document

  field :user_id, type: String
  field :followees, type: BSON::ObjectId
end