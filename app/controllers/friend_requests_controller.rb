class FriendRequestsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_friend, only: %w[create destroy]

  def create
    friend_request = current_user.request_to_be_friends(@friend)
    if friend_request.persisted?
      flash[:notice] = "A friend request to #{@friend.name} has been sent."
    else
      flash[:alert] = friend_request.errors.full_messages.sample
    end
    redirect_back fallback_location: root_path
  end

  def destroy
    friend_request = FriendRequest.find_by(requester: params[:requester_id], requestee: params[:requestee_id])

    if friend_request&.destroy
      flash[:notice] = 'Friend request removed'
    else
      flash[:alert] = 'Could not delete friend request'
    end
    redirect_back fallback_location: root_path
  end

  def sent_requests
    @users = current_user.requestees.paginate(page: params[:page], per_page: 10).with_attached_avatar
  end

  private

  def find_friend
    @friend = User.find(params[:requestee_id])
  end
end
