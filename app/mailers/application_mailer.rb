class ApplicationMailer < ActionMailer::Base
  default from: ENV['PRODUCTION_USER_NAME_SMTP']
  layout 'mailer'
end
