require_relative '../model/tweet'

class FollowService
  def create_follower(params)
    "" "
      One who follows, comes after another.
    " ""
    follow = Follower.new(params)

    create_followee(params)
  end


  private

  def create_followee(params)
    "" "
      One who is followed (has his/her posts monitored by another user).
    " ""
  end
end