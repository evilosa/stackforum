class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_question
  before_action :set_answer, only: [:update]

  after_action :publish_answer, only: [:create]

  include Voted
  include Commented

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    @answer.save
  end

  def update
    @answer.update(answer_params)
  end

  def destroy
    @answer = @question.answers.find(params[:id])
    @answer.destroy
  end

  private

  def set_question
    @question = Question.find(params[:question_id])
  end

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:question_id, :body, :best, :user_id, attachments_attributes: [:id, :file, :_destroy])
  end

  def publish_answer
    return if @answer.errors.any?

    attachments = []
    @answer.attachments.each { |a| attachments << { id: a.id, name: a.file.identifier, url: a.file.url } }
    ActionCable.server.broadcast(
       "question_#{@question.id}",
       action: 'create_answer',
       answer: @answer,
       answer_score: @answer.score,
       attachments: attachments,
       question: @question,
       email: @answer.user.email
    )
  end
end