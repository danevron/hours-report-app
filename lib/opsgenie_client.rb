# require 'httparty'
class OpsgenieClient
  START_TIME = '10:30:00'
  SCHEDULES = ['personalization_schedule', 'myklarna_schedule', 'ondemand_schedule']
  OPSGENIE_API_KEY = "cae80a70-47aa-40f9-bdbc-35d34e5da6f1"

  def self.extract_final_schedule(start_time, end_time)
    SCHEDULES.each do |schedule_name|
      days = ((end_time - start_time) / (24 * 3600)).to_i # hours a day * mins * secs
      options = {
        'apiKey'       => OPSGENIE_API_KEY,
        'name'         => schedule_name,
        'intervalUnit' => 'days',
        'date'         => start_time,
        'interval'     => days
      }
      response = HTTParty.get("https://api.opsgenie.com/v1/json/schedule/timeline", query: options)
      schedule = JSON.parse(response.body)
      rotations = schedule["timeline"]["finalSchedule"]["rotations"]

      periods = rotations.each {|rotation| rotation["periods"]}.flatten
    end
  end
end
      #[2]["periods"]



# # for each day:
# periods_for_day = periods.select {|p| Time.at(p["startTime"]/1000)>=start_time && Time.at(p["startTime"]/1000)<end_time }

# # aggregate periods by user
# periods_aggregation = {}
# periods_for_day.map do |p|
#   user = p["recipients"].first["name"]
#   current_count = periods_aggregation[user] || 0
#   periods_aggregation[user] = current_count + ( (p["endTime"] - p["startTime"])/(3600*1000) )
# end

# # find user with longest period
#     end
#   end
# end