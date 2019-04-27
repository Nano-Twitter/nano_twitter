require_relative '../model/like'

class LikeService

    def self.create_like(params)
        like = Like.new(params)
        if like.save
            # make changes to redis
            $redis.incr_like_count(params[:tweet_id])
            json_result(201, 0, "Like")
        else
            json_result(403, 1, "Unable to like.")
        end
    end

    def self.delete_like(params)
        like = Like.find(BSON::ObjectId(params[:like_id]))
        if like.delete
            # make changes to redis
            $redis.decr_like_count(params[:tweet_id])
            json_result(200, 0, "Unlike.")
        else
            json_result(403, 1, "Unable to unlike.")
        end
    end

    def self.total_likes_by_tweet(params)
        likes = Like.where(tweet_id: BSON::ObjectId(params[:tweet_id])).count
        if likes
            json_result(200, 0, "Likes found.", likes)
        else
            json_result(403, 1, "Likes not found.")
        end
    end

    def self.get_likes_by_tweet(params)
        likes = Like.where(tweet_id: BSON::ObjectId(params[:tweet_id])).order(created_at: :desc).skip(params[:start]).limit(params[:count])
        if likes
            json_result(200, 0, "Likes found.", likes)
        else
            json_result(403, 1, "Likes not found.")
        end
    end

end