class FriendshipsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_user, only: %i[index destroy]
  before_action :find_friend, only: %i[destroy]
  before_action :authorize_current_user, only: %i[destroy]

  def index
    @users = friends(@user)
  end

  def create
    @friend = User.find(params[:friend_id])
    if current_user.accept_friend_request_from(@friend)
      flash[:notice] = "#{@friend.name} added!"
    else
      flash[:alert] = 'Failed to add friend.'
    end

    redirect_back fallback_location: root_path
  end

  def destroy
    if @user.remove_friend(@friend)
      flash[:notice] = "#{@friend.name} successfully removed"
      redirect_back fallback_location: user_friends_path(current_user)
    else
      @users = friends(@user)
      flash.now[:alert] = 'Failed to remove user from your friends list'
      render 'index'
    end
  end

  private

  def friends(user)
    user.friends.paginate(page: params[:page], per_page: 10)
  end

  def find_user
    @user = User.find(params[:user_id])
  end

  def find_friend
    @friend = User.find(params[:id])
  end
end
