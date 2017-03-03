module Commented
  extend ActiveSupport::Concern

  included do
    before_action :set_commentable, only: [:comment, :edit_comment]
    after_action :publish_comment, only: [:comment]

    def comment
      @comment = @commentable.comments.new(comment_params)
      if @comment.save
        render json: { type: controller_name.singularize, action: 'crete_comment', id: @commentable.id, comment: @comment.body  }
      else
        render_error
      end
    end

    def render_error(text = 'Error in comment')
      render json: { error_text: text }, status: :unprocessable_entity
    end

    def edit_comment
      # @commentable.downvote!(current_user)
      #
      # respond_to do |format|
      #   format.html { render_template 'downvote'}
      #   format.json { render json: { type: controller_name.singularize, id: @votable.id, score: @votable.score } }
      # end
    end

  end

  private

  def render_template(action)
    instance_variable_set("@#{controller_name.singularize}", @commentable)
    render "#{controller_name}/#{action}", layout: false
  end

  def model_class
    controller_name.classify.constantize
  end

  def comment_params
    params.require(:comment).permit(:body, :commentable_id, :commentable_type).merge(user: current_user)
  end

  def set_commentable
    @commentable = model_class.find(params[:id])
  end

  def publish_comment
    return if @comment.nil? || @comment.errors.any?

    question_id = @commentable.instance_of?(Question) ? @commentable.id : @commentable.question_id

    ActionCable.server.broadcast(
        "question_#{question_id}",
        action: 'create_comment',
        comment: @comment,
        question_id: question_id,
        comment_email: @comment.user.email
    )
  end
end