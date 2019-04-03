class Like
  include Mongoid::Document

  field :user_id, type: String
  field :tweet_id, type: String
  
end
