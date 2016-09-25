class OnCallCollector
  include Sidekiq::Worker

  def perform(report_id)
    report = Report.find(report_id)
    on_call_shifts = OnCall.where("date BETWEEN ? AND ?", report.start_date, report.end_date)

    on_call_shifts.each do |shift|
      day = (Day.where(date: shift.date).select { |d| d.timesheet.user.email == shift.email }).first
      day.update_attributes(on_call: true) if day
    end
  end
end
