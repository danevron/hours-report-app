class ExpenseReportsController < ApplicationController
  before_action :load_user

  before_action :login_required
  before_action :check_for_list_owner, :only => [:index]

  def index
  end

  private

  def load_user
    @user = User.find(params[:user_id])
  end

  def expense_reports
    @user ? @user.expense_reports : ExpenseReport
  end
end
