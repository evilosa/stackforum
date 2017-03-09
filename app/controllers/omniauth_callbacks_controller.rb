class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    callback('facebook')
  end

  def twitter
    callback('twitter')
  end

  def callback(provider)
    @user = User.find_for_oauth(request.env['omniauth.auth'])
    if @user.email_confirmed?(request.env['omniauth.auth'])
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: provider.capitalize) if is_navigational_format?
    else
      redirect_to omniauth_path
    end
  end
end