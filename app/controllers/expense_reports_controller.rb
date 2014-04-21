class ExpenseReportsController < ApplicationController
  before_action :load_user
  before_action :login_required

  def new
    @expense_report = expense_reports.build_report
  end

  def create
  end

  def index
    expense_reports.all
  end

  def edit
  end

  def update
  end

  private

  def expense_reports
    @user ? @user.expense_reports : ExpenseReport
  end
end
