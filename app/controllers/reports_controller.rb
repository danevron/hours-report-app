class ReportsController < ApplicationController

  before_filter :authenticate_user

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
end
