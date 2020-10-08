class FriendshipsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_user

  def index
    @users = @user.friends.paginate(page: params[:page], per_page: 10)
  end

  private

  def find_user
    @user = User.find(params[:user_id])
  end
end
