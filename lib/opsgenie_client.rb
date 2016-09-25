# require 'httparty'
class OpsgenieClient
  START_TIME = '10:30:00'
  SCHEDULES = ['personalization_schedule', 'myklarna_schedule', 'ondemand_schedule']
  OPSGENIE_API_KEY = "cae80a70-47aa-40f9-bdbc-35d34e5da6f1"

  def self.extract_final_schedule(start_time, end_time)
    days = ((end_time - start_time) / (24 * 3600)).to_i # hours a day * mins * secs
    on_callers = {}

    SCHEDULES.each do |schedule_name|
      on_callers[schedule_name] = {}
      (1..days).each do |i|
        date = start_time + (24 * 3600 * (i-1))
        options = {
          'apiKey'       => OPSGENIE_API_KEY,
          'name'         => schedule_name,
          'intervalUnit' => 'days',
          'date'         => date,
          'interval'     => 1
        }
        response = HTTParty.get("https://api.opsgenie.com/v1/json/schedule/timeline", query: options)
        schedule = JSON.parse(response.body)
        rotations = schedule["timeline"]["finalSchedule"]["rotations"]

        unique_periods = flatten_duplicate_periods(rotations)

        on_callers[schedule_name][date] = calculate_daily_on_caller(unique_periods)
      end
    end

    on_callers
  end

  private

  def self.flatten_duplicate_periods(rotations)
    unique_periods = {}
    rotations.each do |rotation|
      rotation["periods"].each do |period|
        unique_periods["#{period["startTime"]}-#{period["endTime"]}"] = period
      end
    end

    unique_periods
  end

  def self.calculate_daily_on_caller(unique_periods)
    on_call_time = {}
    longest_on_call_time_in_day = 0
    on_caller = ""

    unique_periods.values.each do |period|
      user = period["recipients"].first["name"]
      user_current_on_call_time = on_call_time[user] || 0
      on_call_time[user] = user_current_on_call_time + ( (period["endTime"] - period["startTime"])/(3600*1000) )
      if (on_call_time[user] > longest_on_call_time_in_day)
        longest_on_call_time_in_day = on_call_time[user]
        on_caller = user
      end
    end

    on_caller
  end
end
