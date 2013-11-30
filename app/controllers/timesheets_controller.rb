class TimesheetsController < ApplicationController
  before_action :load_user
  before_action :authenticate_user

  def edit
    @timesheet = timesheets.find(params[:id])
  end

  def update
    @timesheet = timesheets.find(params[:id])

    if @timesheet.update_attributes(timesheet_params)
      if submitted_by_user?
        redirect_to @user, notice: "Your timesheet has been submitted"
      elsif reopened_by_user?
        redirect_to edit_user_timesheet_path(@user, @timesheet), notice: "Timesheet reopened"
      else
        redirect_to edit_user_timesheet_path(@user, @timesheet), notice: "Timesheet saved"
      end
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

  def submitted_by_user?
    params[:commit] == "Submit Timesheet"
  end

  def reopened_by_user?
    params[:commit] == "Reopen Timesheet"
  end

  def timesheet_params
    request_params = params.require(:timesheet).permit(:comments, :status,
      :days_attributes => [:id, :day_type, :value, :comment])
    add_status_to_params(request_params)
  end

  def add_status_to_params(parameters)
    case params[:commit]
    when "Submit Timesheet"
      parameters.merge(:status => "submitted")
    when "Reopen Timesheet"
      parameters.merge(:status => "reopened")
    when "Update Changes"
      parameters
    end
  end
end
