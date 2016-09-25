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

        unique_periods = {}
        rotations.each do |rotation|
          rotation["periods"].each do |period|
            unique_periods["#{period["startTime"]}-#{period["endTime"]}"] = period
          end
        end

        periods_aggregation = {}
        max_period_length = 0
        on_call = ""
        unique_periods.values.each do |period|
          user = period["recipients"].first["name"]
          current_count = periods_aggregation[user] || 0
          periods_aggregation[user] = current_count + ( (period["endTime"] - period["startTime"])/(3600*1000) )
          if (periods_aggregation[user] > max_period_length)
            max_period_length = periods_aggregation[user]
            on_call = user
          end
        end

        on_callers[schedule_name][date] = on_call
      end
    end
  end
end