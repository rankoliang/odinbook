class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_current_user, only: %i[edit]
  before_action :find_user, only: %i[show edit update]

  def index
    @users = User.paginate(page: params[:page], per_page: 10)
  end

  def show; end

  def edit; end

  def update
    if @user.update(profile_params)
      redirect_to @user, notice: 'Successfully updated!'
    else
      flash.now[:alert] = 'Update failed!'
      render 'edit'
    end
  end

  private

  def profile_params
    params.require(:user).permit(:name, :summary, :avatar)
  end

  def authorize_current_user
    if params[:id].to_i == current_user.id
      @user = current_user
    else
      render file: Rails.root.join('public', '401.html'), status: :unauthorized
    end
  end

  # rubocop:disable Naming/MemoizedInstanceVariableName
  def find_user
    @user ||= User.find(params[:id])
  end
  # rubocop:enable Naming/MemoizedInstanceVariableName
end
