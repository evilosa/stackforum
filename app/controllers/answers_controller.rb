class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_question
  before_action :set_answer, only: [:update, :destroy]

  respond_to :js
  respond_to :json, only: :create

  after_action :publish_answer, only: [:create]

  include Voted
  include Commented

  def create
    respond_with (@answer = @question.answers.create(answer_params))
  end

  def update
    respond_with @answer.update(answer_params)
  end

  def destroy
    respond_with @answer.destroy
  end

  private

  def set_question
    @question = Question.find(params[:question_id])
  end

  def set_answer
    @answer = @question.answers.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:question_id, :body, :best, :user_id, attachments_attributes: [:id, :file, :_destroy]).merge(user: current_user)
  end

  def publish_answer
    return if @answer.errors.any?

    answer = AnswerPresenter.new(@answer).as('publish')
    ActionCable.server.broadcast(
       "question_#{@question.id}_answers",
       answer
    )
  end
end