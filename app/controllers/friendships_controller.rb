class FriendshipsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_user
  before_action :find_friend
  before_action :authorize_current_user

  def create; end

  def destroy; end

  private

  def find_user
    @user = User.find(params[:user_id])
  end

  def find_friend
    @friend = User.find(params[:friend_id])
  end
end
