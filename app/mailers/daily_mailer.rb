class DailyMailer < ApplicationMailer

  def digest(user)
    @user = user
    @questions = Question.where('created_at > ?', 1.days.ago)
    mail(to: @user.email, subject: 'StackForum. Daily updates.')
  end
end