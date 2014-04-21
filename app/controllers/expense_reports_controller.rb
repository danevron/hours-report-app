class ExpenseReportsController < ApplicationController
  before_action :load_user
  before_action :login_required

  def new
    @expense_report = expense_reports.build_report
  end

  def create
    @expense_report = expense_reports.new(expense_report_params)

    if @expense_report.save
      redirect_to_expense_report(@expense_report)
    else
      render "new"
    end
  end

  def show
    @expense_report = expense_reports.find(params[:id])
  end

  def index
    @expense_reports = expense_reports.all
  end

  def edit
  end

  def update
  end

  private

  def expense_reports
    @user ? @user.expense_reports : ExpenseReport
  end

  def expense_report_params
    params.require(:expense_report).permit(:start_time, :end_time, :country, :currency,
      :expenses_attributes => [:id, :description, :quantity, :amount, :currency])
  end

  def redirect_to_expense_report(expense_report)
    redirect_to(expense_report.user ? [expense_report.user, expense_report] : expense_report)
  end
end
