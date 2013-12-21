class ReportsController < ApplicationController
  respond_to :xls, :html


  before_action :login_required
  before_action :role_required

  def index
    @reports = Report.all
  end

  def show
    @report = Report.find(params[:id])
    respond_to do |format|
      format.html
      format.xlsx { render xlsx: :show, filename: "report" }
    end
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
    params.require(:report).permit(:start_date, :end_date, :current, :tenbis_date)
  end
end
