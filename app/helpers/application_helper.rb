module ApplicationHelper

  def bootstrap_class_for(flash_type)
    case flash_type
      when "notice"
        "alert-success"
      when "info"
        "alert-info"
      when "warning"
        "alert-warning"
      when "alert"
        "alert-danger"
      else
        flash_type.to_s
    end
  end


  def render_google_tag_manager
    render "/shared/google_tag_manager" if Rails.env.production?
  end

  def add_units(day_type)
    case day_type
    when "Workday"
      "#{day_type} (Hours)"
    when "Weekend", "Holiday"
      "#{day_type}"
    else
      "#{day_type} (Days)"
    end
  end
end
