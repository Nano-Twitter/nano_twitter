class User
  include Mongoid::Document
  field :id, type: Integer
  field :name, type: String
  field :password, type: String
  field :bio, type: String
  field :gender, type: Integer
  field :follower, type: BSON::Binary
  field :followee, type: BSON::Binary
end
