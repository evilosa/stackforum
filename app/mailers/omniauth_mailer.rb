class OmniauthMailer < ApplicationMailer
  def confirmation_email(params)
    @provider = params[:provider]
    @uid = params[:uid]
    @confirmation_token = params[:confirmation_token]
    @email = params[:email]
    @temp_email = params[:temp_email]
    mail(to: @email, subject: 'Confirm your email')
  end
end