class Hashtag
  include Mongoid::Document
  field :id, type: Integer
  field :name, type: String
end
