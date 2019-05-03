require_relative '../model/like'

class LikeService

    def self.create_like(params)
        like = Like.new(params)
        if like.save
            # make changes to redis
            json_result(201, 0, "Like")
        else
            json_result(403, 1, "Unable to like.")
        end
    end

    def self.delete_like(params)
        like = Like.find(BSON::ObjectId(params[:like_id]))
        if like.delete
            # make changes to redis
            json_result(200, 0, "Unlike.")
        else
            json_result(403, 1, "Unable to unlike.")
        end
    end

end