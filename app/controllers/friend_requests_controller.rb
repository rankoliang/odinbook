class FriendRequestsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_friend

  def create
    redirect_back fallback_location: root_path,
                  notice: "A friend request to #{@friend.name} has been sent."
  end

  def destroy; end

  private

  def find_friend
    @friend = User.find(params[:requestee_id])
  end
end
