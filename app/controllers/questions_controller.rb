class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:show, :best_answer, :update_body, :update, :destroy]
  before_action :build_answer, only: [:show]
  after_action :publish_question, only: [:create]

  include Voted
  include Commented


  respond_to :html
  respond_to :js, only: [:best_answer, :update_body]

  def index
    respond_with (@questions = Question.all)
  end

  def show
    gon.question_id = @question.id
    respond_with @question
  end

  def new
    respond_with (@question = current_user.questions.new)
  end

  def create
    respond_with (@question = current_user.questions.create(question_params))
  end

  def best_answer
    respond_with @question.best_answer!(params)
  end

  def update
    if current_user.author_of?(@question)
      @question.update(question_params)
      respond_with @question
    end
  end

  def update_body
    respond_with @question.update(body: question_params[:body])
  end

  def destroy
    respond_with (@question.destroy) if current_user.author_of?(@question)
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

  def build_answer
    @answer = @question.answers.build
  end

  def question_params
    params.require(:question).permit(:title, :body, :user_id, :bootsy_image_gallery_id, attachments_attributes: [:id, :file, :_destroy], votes_attributes: [:id, :_destroy])
  end
end
