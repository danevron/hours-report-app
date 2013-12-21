class TenbisUsageCollector
  include Sidekiq::Worker

  def perform(report_id)
    report = Report.find(report_id)
    tenbis = Tenbis.find_by(:date => report.tenbis_date)

    report.timesheets.each do |timesheet|
      timesheet.tenbis_usage = tenbis.usage[timesheet.user.name.downcase] || 0
      timesheet.save
    end
  end
end
