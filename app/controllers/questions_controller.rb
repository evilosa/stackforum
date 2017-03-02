class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:show, :best_answer, :update_body, :update, :destroy]
  after_action :publish_question, only: [:create]

  include Voted

  def index
    @questions = Question.all
  end

  def show
    @answer = Answer.new
    @answer.attachments.build
  end

  def new
    @question = current_user.questions.new
    @question.attachments.build
  end

  def create
    @question = current_user.questions.new(question_params)
    if @question.save
      redirect_to @question, notice: t('common.messages.questions.create')
    else
      render :new
    end
  end

  def best_answer
    @question.best_answer!(params)
  end

  def update
    @question.update(question_params) if current_user.author_of?(@question)
  end

  def update_body
    @question.update(body: question_params[:body])
    render :update_body
  end

  def destroy
    if current_user.author_of?(@question)
      @question.destroy
      redirect_to questions_path, notice: t('common.messages.questions.destroy')
    else
      redirect_to @question, notice: t('common.errors.not_allow')
    end
  end

  private

  def load_question
    @question = Question.find(params[:id])
  end

  def publish_question
    return if @question.errors.any?

    ActionCable.server.broadcast(
      'questions',
      ApplicationController.render(
         partial: 'questions/question',
         locals: { question: @question }
      )
    )
  end

  def question_params
    params.require(:question).permit(:title, :body, :user_id, :bootsy_image_gallery_id, attachments_attributes: [:id, :file, :_destroy], votes_attributes: [:id, :_destroy])
  end
end
