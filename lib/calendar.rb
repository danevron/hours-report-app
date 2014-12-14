class Calendar

  def self.holidays_between(from, to)
    if same_period_as_last_query?(from, to)
      @holidays
    else
      get_holidays(from, to)
    end
  end

  def self.personal_events(user_access_token, email, from, to)
    params = { :parameters => {
        "calendarId" => email,
        "timeMin" => from.to_datetime,
        "timeMax" => to.to_datetime,
        "q" => ENV['PERSONAL_CALENDAR_MARK']
      }
    }

    get_calendar_events(user_access_token, params)
  end

  private

  def self.get_holidays(from, to)
    params = { :parameters => {
        "calendarId" => holidays_calendar_id,
        "timeMin" => from.to_datetime,
        "timeMax" => to.to_datetime
      }
    }

    @holidays = get_calendar_events(admin_access_token, params)
  end

  def self.get_calendar_events(token, params)
    client = Google::APIClient.new
    client.authorization.access_token = token
    service = client.discovered_api('calendar', 'v3')
    response = client.execute({ :api_method => service.events.list }.merge(params))
    parse(response.data, params[:parameters]["calendarId"])
  end


  def self.parse(google_data, creator)
    formatted_events = {}

    full_day_events_filtered_by_creator = google_data.items.select { |event|
      event.creator.email == creator && event.start.date.present?
    }

    full_day_events_filtered_by_creator.each do |event|
      (Date.parse(event.start.date)..Date.parse(event.end.date) - 1).each do |date|
        formatted_events[date] = event.summary
      end
    end
    formatted_events
  end

  def self.admin_access_token
    User.admins.last.access_token_for_api
  end

  def self.holidays_calendar_id
    ENV['HOLIDAYS_CALENDAR_ID']
  end

  def self.same_period_as_last_query?(from, to)
    if @from == from && @to == to
      true
    else
      @from = from
      @to = to
      false
    end
  end
end
