class Hashtag
  include Mongoid::Document

  field :name, type: String

  has_and_belongs_to_many :tweets, inverse_of: :hastags
  has_and_belongs_to_many :comments, inverse_of: :hastags

end
