class RemindersController < ApplicationController
  before_action :load_report

  def create
    reminder = @report.reminders.new
    reminder.save
    redirect_to @report, :notice => "Reminders are being sent"
  end

  private

  def load_report
    @report = Report.find(params[:report_id])
  end
end
