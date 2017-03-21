module Subscribed
  extend ActiveSupport::Concern

  included do
    before_action :set_subscribable, only: [:subscribe, :unsubscribe]
  end

  def subscribe
    @subscribable.subscribe!(current_user)

    respond_to do |format|
      format.html { render_template 'subscribe'}
      format.json { render json: { type: controller_name.singularize, id: @subscribable.id } }
    end
  end

  def unsubscribe
    @subscribable.unsubscribe!(current_user)

    respond_to do |format|
      format.html { render_template 'unsubscribe'}
      format.json { render json: { type: controller_name.singularize, id: @subscribable.id } }
    end
  end

  private

  def render_template(action)
    instance_variable_set("@#{controller_name.singularize}", @subscribable)
    render "#{controller_name}/#{action}", layout: false
  end

  def model_class
    controller_name.classify.constantize
  end

  def set_subscribable
    @subscribable = model_class.find(params[:id])
  end
end