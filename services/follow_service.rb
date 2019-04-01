require_relative '../model/tweet'

class FollowService
  def self.follow(params)
    #   One who follows, comes after another.
    follower = User.find(BSON::ObjectId(params[:follower_id]))
    followee = User.find(BSON::ObjectId(params[:followee_id]))
    begin
      follower.follow!(followee)
      json_result(200, 0, 'Follow successfully')
    rescue => e
      json_result(403, 1, 'Fail to follow')
    end
    
  end

  def self.unfollow(params)
    #   One who is followed (has his/her posts monitored by another user).
    follower = User.find(BSON::ObjectId(params[:follower_id]))
    followee = User.find(BSON::ObjectId(params[:followee_id]))
    begin
      follower.unfollow!(followee)
      json_result(200, 0, 'Unfollow successfully')
    rescue => e
      json_result(403, 1, 'Fail to unfollow')
    end
  end

  def self.get_follower_ids(params)
    
  end

  def self.get_followee_ids(params)
    
  end

  def self.get_followers(params)
    
  end

  def self.get_followees(params)
    
  end

end

