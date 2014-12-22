class TenbisUsageCollector
  include Sidekiq::Worker

  def perform(report_id)
    report = Report.find(report_id)
    tenbis = Tenbis.find_by(:date => report.tenbis_date + 2.hours)

    report.timesheets.each do |timesheet|
      if timesheet.tenbis_usage.nil?
        timesheet.tenbis_usage = tenbis.usage[timesheet.user.tenbis_number] || 0
        timesheet.save
      end
    end
  end
end
