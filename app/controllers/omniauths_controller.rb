class OmniauthsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def show
  end

  def update_email
    OmniauthMailer.confirmation_email(secure_params).deliver
    redirect_to new_user_session_path
  end

  def confirm_email
    if User.confirm_oauth_email(secure_params)
      @user = User.find_by_email(secure_params[:email])
      sign_in @user, event: :authentication
      redirect_to root_path
    else
      redirect_to new_user_session_path
    end
  end

  private

  def secure_params
    params.permit(:email, :provider, :uid, :temp_email, :confirmation_token)
  end
end