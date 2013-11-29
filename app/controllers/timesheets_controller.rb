class TimesheetsController < ApplicationController
  before_action :load_user
  before_action :authenticate_user

  def edit
    @timesheet = timesheets.find(params[:id])
  end

  def update
    @timesheet = timesheets.find(params[:id])

    if @timesheet.update_attributes(timesheet_params)
      redirect_to edit_user_timesheet_path(@user, @timesheet), notice: "Timesheet saved"
    else
      render :action => "edit"
    end
  end

  private

  def load_user
    @user = User.find(params[:user_id])
  end

  def timesheets
    @user ? @user.timesheets : Timesheet
  end

  def timesheet_params
    params.require(:timesheet).permit(:comments, :status,
      :days_attributes => [:id, :day_type, :value, :comment])
  end
end
