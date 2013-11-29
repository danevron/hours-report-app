class TimesheetsController < ApplicationController

  before_action :authenticate_user

  def edit
    @user = User.find(params[:user_id])
    @timesheet = Timesheet.find(params[:id])
  end

  def update

  end
end
