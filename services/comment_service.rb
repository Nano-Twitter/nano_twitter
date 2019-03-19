require_relative '../model/comment'

class CommentService

    def self.create_comment(params)
        comment = Comment.new(params)
        if comment.save
            json_result(201, 0, "Comment sent out!")
        else
            json_result(403, 1, "Comment failed to be sent out.")
        end
    end

    def self.delete_comment(params)
        comment = Comment.find(BSON::ObjectId(params[:comment_id]))
        if comment.delete
            json_result(200, 0, "Comment deleted successfully.")
        else
            json_result(403, 1, "Unable to delete the comment.")
        end
    end

    def self.get_comment_by_tweet(params)
        comments = Comment.where(tweet_id: BSON::ObjectId(params[:tweet_id])).order(created_at: :desc).skip(params[:start]).limit(params[:count])
        if comments
            json_result(200, 0, "Comments found.", comments)
        else
            json_result(403, 1, "Comments not found.")
        end
    end

    def self.total_comment_by_tweet(params)
        comments = Comment.where(tweet_id: BSON::ObjectId(params[:tweet_id])).count
        if comments
            json_result(200, 0, "Comments found.", comments)
        else
            json_result(403, 1, "Comments not found.")
        end
    end

end