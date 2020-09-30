class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_current_user, only: %i[edit]
  before_action :find_user, only: %i[show edit]

  def index
    @users = User.paginate(page: params[:page], per_page: 10)
  end

  def show; end

  def edit; end

  private

  def authorize_current_user
    if params[:id].to_i == current_user.id
      @user = current_user
    else
      render file: 'public/401', status: :unauthorized
    end
  end

  # rubocop:disable Naming/MemoizedInstanceVariableName
  def find_user
    @user ||= User.find(params[:id])
  end
  # rubocop:enable Naming/MemoizedInstanceVariableName
end
