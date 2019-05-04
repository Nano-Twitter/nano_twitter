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
      pp e
      json_result(403, 1, 'Fail to follow')
    end
    
  end

  def self.unfollow(params)
    #   One who is followed (has his/her posts monitored by another user).
    follower = User.find(BSON::ObjectId(params[:follower_id]))
    followee = User.find(BSON::ObjectId(params[:followee_id]))
    begin
      follower.unfollow!(followee)
      $redis.delete_timeline("timeline_" + params[:follower_id])
      json_result(200, 0, 'Unfollow successfully')
    rescue => e
      pp e
      json_result(403, 1, 'Fail to unfollow')
    end
  end

  def self.get_follower_ids(params)
    user = User.find(BSON::ObjectId(params[:user_id]))
    if user
      json_result(200, 0, 'Get follower ids', user.follower_ids)
    else
      json_result(403, 1, 'Unable to get follower ids')
    end
  end

  def self.get_followee_ids(params)
    user = User.find(BSON::ObjectId(params[:user_id]))
    if user
      json_result(200, 0, 'Get followee ids', user.followee_ids)
    else
      json_result(403, 1, 'Unable to get followee ids')
    end
  end

  def self.get_followers(params)
    user = User.find(BSON::ObjectId(params[:user_id]))
    page_num = params[:page_num] || 1
    page_size = params[:page_size] || 20
    if user
      # User.find(user.follower_ids)[page_num * page_size - page_size...page_num * page_size]
      json_result(200, 0, 'Get followers', User.where(following_ids:BSON::ObjectId(params[:user_id])).skip(page_num * page_size - page_size).limit(page_size))
      # json_result(200, 0, 'Get followers', User.find(user.followers_ids)[page_num * page_size - page_size...page_num * page_size])
    else
      json_result(403, 1, 'Unable to get followers')
    end
  end

  def self.get_followees(params)
    user = User.find(BSON::ObjectId(params[:user_id]))
    page_num = params[:page_num] || 1
    page_size = params[:page_size] || 20
    if user
      json_result(200, 0, 'Get followees', User.where(follower_ids:BSON::ObjectId(params[:user_id])).skip(page_num * page_size - page_size).limit(page_size))
      # json_result(200, 0, 'Get followees', User.find(user.following_ids)[page_num * page_size - page_size...page_num * page_size])

    else
      json_result(403, 1, 'Unable to get followees')
    end
  end

end

