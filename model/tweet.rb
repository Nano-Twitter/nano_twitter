class Tweet
  include Mongoid::Document

  field :user_id, type: String
  field :content, type: String
  field :parent_id, type: Integer

  belongs_to :user
  
end
