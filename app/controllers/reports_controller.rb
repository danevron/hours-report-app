class ReportsController < ApplicationController

  before_action :authenticate_user

  date_params :start_date, :end_date, namespace: :report, only: [:create]
  def index
    @reports = Report.all
  end

  def show
  end

  def new
    @report = Report.new
  end

  def create
  end

  private

  def report_params
    params.require(:report).permit(:start_date, :end_date)
  end
end
