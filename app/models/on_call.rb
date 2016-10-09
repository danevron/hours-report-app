class OnCall < ActiveRecord::Base

  def self.update_period(start_date, end_date)
    Time.zone = "Asia/Jerusalem"
    start_time = Time.zone.parse(start_date.to_s) + (10.5).hours
    end_time = Time.zone.parse(end_date.to_s) + 1.day + (10.5).hours # we want to include the last day of the month too
    on_call_schedules = OpsgenieClient.extract_final_schedule(start_time, end_time)

    on_call_schedules.each do |schedule, on_call_days|
      on_call_days.each do |day, email|
        self.create(date: day.to_date, email: email, schedule: schedule)
      end
    end
  end
end
