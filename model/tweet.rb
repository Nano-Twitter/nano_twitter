class Tweet
  include Mongoid::Document

  field :user_id, type: Integer
  field :content, type: String
  field :parent_id, type: Integer

  validates_presence_of :user_id
  validates_presence_of :content
end
