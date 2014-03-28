class Calendar

  def self.holidays_between(from, to)
    if same_period_as_last_query?(from, to)
      @holidays
    else
      get_holidays(from, to)
    end
  end

  def self.get_personal_events(user_access_token, email, from, to)
    params = { :parameters => {
        "calendarId" => email,
        "timeMin" => from.to_datetime,
        "timeMax" => to.to_datetime,
        "q" => "OPEN"
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
    parse(response.data)
  end


  def self.parse(google_data)
    binding.pry
    events = {}
    google_data.items.each do |event|
      events[Date.parse(event.start.date)] = event.summary
    end
    events
  end

  def self.admin_access_token
    User.admins.first.access_token_for_api
  end

  def self.holidays_calendar_id
    ENV['GOOGLE_CALENDAR_IDENTIFIER']
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
