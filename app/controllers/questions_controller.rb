class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:show, :edit, :destroy]

  def index
    @questions = Question.all
  end

  def show
    @answer = Answer.new
  end

  def new
    @question = current_user.questions.new
  end

  def edit
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
    @question = Question.find(params[:question_id])
    @new_best_answer = @question.answers.where(id: params[:answer_id]).first
    @old_best_answer = @question.answers.where('best = true')
    @old_best_answer.update(best: false) unless @old_best_answer.nil?
    @new_best_answer.update(best: true)
  end

  def update_body
    @question = Question.find(params[:question_id])
    @question.update(body: question_params[:body])
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

  def question_params
    params.require(:question).permit(:title, :body, :user_id, :bootsy_image_gallery_id)
  end
end
