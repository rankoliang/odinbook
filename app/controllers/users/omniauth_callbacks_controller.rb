class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  skip_before_action :verify_authenticity_token, only: :discord

  def discord
    @user = User.from_omniauth(request.env['omniauth.auth'])
    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication # this will throw if @user is not activated
      set_flash_message(:notice, :success, kind: 'Discord') if is_navigational_format?
    else
      session['devise.discord_data'] = request.env['omniauth.auth'].except(:extra) # extra can overflow some session stores
      redirect_to root_path
    end
  end

  def failure
    redirect_to root_path
  end
end
