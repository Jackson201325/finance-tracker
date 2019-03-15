class FriendshipsController < ApplicationController

  def destroy
    #grab the realtionship in an instance from the friendships table
    @friendship = current_user.friendships.where(friend_id: params[:id]).first
    @friendship.destroy
    redirect_to my_friends_path
  end

end
