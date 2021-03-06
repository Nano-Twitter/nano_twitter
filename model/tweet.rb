class Tweet
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic
  include Mongoid::Timestamps

  field :user_id, type: BSON::ObjectId
  field :content, type: String
  field :parent_id, type: BSON::ObjectId
  field :root_id, type: BSON::ObjectId
  field :retweet_count, type: Integer, default: 0
  field :comments_count, type: Integer, default: 0
  field :image_url, type:String, default:''


  belongs_to :user, counter_cache: true

  index({created_at: 1})
  index({user_id: 1})
  index({content: 'text'})

  has_many :comments

end
