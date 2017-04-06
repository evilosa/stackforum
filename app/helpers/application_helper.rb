module ApplicationHelper
    def active_controller?(controller_name, class_name = nil)
        if params[:controller] == controller_name
         class_name ||= "active"
        else
           nil
        end
    end

    def active_action?(action_name)
        params[:action] == action_name ? "active" : nil
    end

  def collection_cache_key_for(model)
    klass = model.to_s.capitalize.constantize
    count = klass.count
    max_updated_at = klass.maximum(:updated_at).try(:utc).try(:to_s, :number)
    "#{model.to_s.pluralize}/collection-#{count}-#{max_updated_at}"
  end
end
