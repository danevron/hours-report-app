class ExpenseReportsController < ApplicationController
  before_action :load_user

  before_action :login_required
  before_action :set_owner_check_object, :only => [:index]
  before_action :owner_required,         :only => [:index]

  def index
  end

  private

  def set_owner_check_object
    @owner_check_object = expense_reports.first
  end

  def load_user
    @user = User.find(params[:user_id])
  end

  def expense_reports
    @user ? @user.expense_reports : ExpenseReport
  end
end
