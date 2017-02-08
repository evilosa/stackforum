class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_question

  def destroy
    @answer = @question.answers.find(params[:id])
    if current_user.author_of?(@answer)
      @answer.destroy
      redirect_to @question, notice: t('common.messages.answers.destroy')
    else
      redirect_to @question, notice: t('common.errors.not_allow')
    end
  end

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    if @answer.save
      redirect_to @question, notice: t('common.messages.answers.create')
    else
      redirect_to @question, error: @answer.errors.full_messages
    end
  end

  private

  def set_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:question_id, :body, :user_id)
  end
end