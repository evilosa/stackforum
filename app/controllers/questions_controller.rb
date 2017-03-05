class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:show, :best_answer, :update_body, :update, :destroy]
<<<<<<< c4fe4db3a272aabfc643a524544c45d9659a05ad
  after_action :publish_question, only: [:create]

  include Voted
  include Commented
=======
  before_action :build_answer, only: [:show]

  respond_to :html
>>>>>>> Refactor question controller.

  def index
    respond_with (@questions = Question.all)
  end

  def show
<<<<<<< c4fe4db3a272aabfc643a524544c45d9659a05ad
    @answer = Answer.new
    @answer.attachments.build
    gon.question_id = @question.id
=======
    respond_with @question
>>>>>>> Refactor question controller.
  end

  def new
    respond_with (@question = current_user.questions.new)
  end

  def create
    respond_with (@question = current_user.questions.create(question_params))
  end

  def best_answer
    @question.best_answer!(params)
  end

  def update
    if current_user.author_of?(@question)
      @question.update(question_params)
      respond_with @question
    end
  end

  def update_body
    @question.update(body: question_params[:body])
    render :update_body
  end

  def destroy
    respond_with (@question.destroy) if current_user.author_of?(@question)
  end

  private

  def load_question
    @question = Question.find(params[:id])
  end

<<<<<<< c4fe4db3a272aabfc643a524544c45d9659a05ad
  def publish_question
    return if @question.errors.any?

    ActionCable.server.broadcast(
      'questions',
      ApplicationController.render(
         partial: 'questions/question',
         locals: { question: @question }
      )
    )
=======
  def build_answer
    @answer = @question.answers.build
>>>>>>> Refactor question controller.
  end

  def question_params
    params.require(:question).permit(:title, :body, :user_id, :bootsy_image_gallery_id, attachments_attributes: [:id, :file, :_destroy], votes_attributes: [:id, :_destroy])
  end
end
