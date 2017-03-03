class CommentsController < ApplicationController
  before_action :authenticate_user!

  after_action :publish_comment, only: [:create]

  def create
    unless Comment.types.include?(params[:comment][:commentable_type])
      return render_error
    end
  end

  def render_error(text = 'Error in comment')
    render json: { error_text: text }, status: :unprocessable_entity
  end

  def commentable
    @commentable ||= params[:comment][:commentable_type].constantize.find(params[:comment][:commentable_id])
  end

  def comment_params
    params.require(:comment).permit(:body).merge(user: current_user)
  end

  def publish_comment
    return if @comment.nil? || @comment.errors.any?

    ActionCable.server.broadcast(
       'comments',
       body: @comment.body,
       comment_author: @comment.user_id
    )
  end
end