class UserReportsController < ApplicationController

  before_action :authenticate_user

  def edit
    @user = User.find(params[:user_id])
    @user_report = UserReport.find(params[:id])
  end

  def update

  end
end
