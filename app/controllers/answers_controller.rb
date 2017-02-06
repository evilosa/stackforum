class AnswersController < ApplicationController
  before_action :set_question, only: [:new, :create]

  def new
    @answer = Answer.new
  end

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    if @answer.save
      redirect_to @question
    else
      redirect_to @question, notice: @answer.errors.full_messages
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