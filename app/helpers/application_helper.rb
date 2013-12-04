module ApplicationHelper

  def bootstrap_class_for flash_type
    case flash_type
      when :notice
        "alert-success"
      when :info
        "alert-info"
      when :warning
        "alert-warning"
      when :alert
        "alert-danger"
      else
        flash_type.to_s
    end
  end

  def panel_class_by_status(status)
    case status
      when "open"
        "panel-info"
      when "submitted"
        "panel-success"
      else
        "panel-default"
    end
  end
end
