class Calendar

  def self.holidays_between(from, to)
    @holidays ||= get_holidays_from_google(calendar_id, access_token, from, to)
  end

  private

  def self.get_holidays_from_google(calendar_id, access_token, from, to)
    client = Google::APIClient.new
    client.authorization.access_token = access_token
    service = client.discovered_api('calendar', 'v3')
    response = client.execute(:api_method => service.events.list,
      :parameters => {
        "calendarId" => calendar_id,
        "timeMin" => from.to_datetime,
        "timeMax" => to.to_datetime
      }
    )
    @holidays = parse_holidays(response.data)
  end

  def self.parse_holidays(google_data)
    holidays = {}
    google_data.items.each do |event|
      holidays[Date.parse(event.start.date)] = event.summary
    end
    holidays
  end

  def self.access_token
    User.admins.first.access_token_for_api
  end

  def self.calendar_id
    ENV['GOOGLE_CALENDAR_IDENTIFIER']
  end
end
