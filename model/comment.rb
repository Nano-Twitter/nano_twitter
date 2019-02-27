class Comment
  include Mongoid::Document

  field :user_id, type: Integer
  field :tweet_id, type: Integer
  field :content, type: String
end
