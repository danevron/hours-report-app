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
end
