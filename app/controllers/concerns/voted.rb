module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_votable, only: [:upvote, :downvote]
  end

  def upvote
    @votable.upvote!(current_user)

    respond_to do |format|
      format.html { render_template 'upvote'}
      format.json { render json: { type: controller_name.singularize, id: @votable.id, score: @votable.score } }
    end
  end

  def downvote
    @votable.downvote!(current_user)

    respond_to do |format|
      format.html { render_template 'downvote'}
      format.json { render json: { type: controller_name.singularize, id: @votable.id, score: @votable.score } }
    end
  end

  private

  def render_template(action)
    instance_variable_set("@#{controller_name.singularize}", @votable)
    render "#{controller_name}/#{action}", layout: false
  end

  def model_klass
    controller_name.classify.constantize
  end

  def set_votable
    @votable = model_klass.find(params[:id])
  end
end