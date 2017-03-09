class OmniauthsController < ApplicationController
  def show
  end

  def update_email
    permited = omniauth_params
    data = 34
  end

  private

  def omniauth_params
    params.permit(:email).merge(user: current_user)
  end
end