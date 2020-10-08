class FriendshipsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_user
  before_action :authorize_current_user

  def index
    @users = @user.friends.paginate(page: params[:page], per_page: 10)
  end

  def destroy
    redirect_back fallback_location: user_friends_path(current_user)
  end

  private

  def find_user
    @user = User.find(params[:user_id])
  end
end
