class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_user, except: %i[index]
  before_action :authorize_current_user, except: %i[index show]

  def index
    @users = User.paginate(page: params[:page], per_page: 10).with_attached_avatar
  end

  def show; end

  def edit; end

  def update
    if @user.update(profile_params)
      redirect_to @user, notice: 'Successfully updated!'
    else
      flash.now[:alert] = 'Update failed.'
      render 'edit'
    end
  end

  def destroy_attached_avatar
    @user.avatar.purge if @user.avatar.attached?
    redirect_back(fallback_location: user_path(@user))
  end

  private

  def profile_params
    params.require(:user).permit(:name, :summary, :avatar)
  end

  def authorize_current_user
    return if @user == current_user

    render file: Rails.root.join('public', '401.html'), status: :unauthorized
  end

  def find_user
    @user = User.find(params[:id])
  end
end
