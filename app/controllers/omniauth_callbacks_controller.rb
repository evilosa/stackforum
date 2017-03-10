class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    callback('facebook')
  end

  def twitter
    callback('twitter')
  end

  def callback(provider)
    @provider = request.env['omniauth.auth'][:provider]
    @uid = request.env['omniauth.auth'][:uid]
    @user = User.find_for_oauth(request.env['omniauth.auth'])
    if @user.email_confirmed?(request.env['omniauth.auth'])
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: provider.capitalize) if is_navigational_format?
    else
      redirect_to omniauth_path(provider: @provider, uid: @uid, temp_email: @user.email, confirmation_token: @user.confirmation_token)
    end
  end
end