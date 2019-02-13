class Tweet
  include Mongoid::Document
  field :id, type: Integer
  field :user_id, type: Integer
  field :content, type: String
  field :parent_id, type: Integer
end
