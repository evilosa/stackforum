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
end
