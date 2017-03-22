class SubscriptionMailer < ApplicationMailer

  def notify(user, answer)
    @user = user
    @answer = answer
    @question = answer.question

    mail(to: @user.email, subject: 'StackForum. Daily updates.')
  end
end