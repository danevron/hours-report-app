class OnCallWorker
  include Sidekiq::Worker

  def perform(report_id)
    report = Report.find(report_id)
    OnCall.update_period(report.start_date, report.end_date)
    OnCallCollector.perform_async(report_id)
  end
end
