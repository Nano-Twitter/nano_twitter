class Hashtag
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic
  field :name, type: String

  has_and_belongs_to_many :tweets, inverse_of: :hastags
  has_and_belongs_to_many :comments, inverse_of: :hastags

end
