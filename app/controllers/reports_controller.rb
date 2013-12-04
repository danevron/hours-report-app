class ReportsController < ApplicationController

  before_action :authenticate_user

  def index
    @reports = Report.all
  end

  def show
    @report = Report.find(params[:id])
  end

  def new
    @report = Report.new
  end

  def create
    @report = Report.build_report(report_params)

    if @report.save
      redirect_to reports_path, notice: "Report created"
    else
      render "new"
    end
  end

  private

  def report_params
    params.require(:report).permit(:start_date, :end_date, :current)
  end
end
