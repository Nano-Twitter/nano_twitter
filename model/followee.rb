class Followee
    include Mongoid::Document

    field :user_id, type: Integer
    field :followees, type: Array
end