class Api::V1::ExpenseReportsController < Api::V1::ApiController
  inherit_resources
  include ExpenseReportsHelper

  before_action :load_user, :only => [:index]
  before_action :check_for_list_owner, :only => [:index]

  # The order of the after actions is important, it's not wrong!!
  after_action :check_for_list_owner, :only => [:show, :edit]
  after_action :load_user_from_respense, :only => [:show, :edit]

  def create
    expense_report = ExpenseReport.new(safe_params)
    update_submit_time(expense_report)

    if expense_report.save
      render :json => expense_report
    else
      render :json => expense_report.errors, :status => :unprocessable_entity
    end
  end

  def index
    @expense_reports = ExpenseReport.where({})
    [:user_id].each do |p|
      if params[p].present?
        @expense_reports = @expense_reports.where( p => params[p] )
      end
    end
    render :json => @expense_reports
  end

  def update
    expense_report = ExpenseReport.find(params[:id])
    expense_report.expenses.destroy_all
    expense_report.update_attributes(safe_params)
    update_submit_time(expense_report)

    if expense_report.save
      render :json => expense_report
    else
      render :json => expense_report.errors, :status => :unprocessable_entity
    end
  end

  def show
    @expense_report = ExpenseReport.find(params[:id])

    respond_to do |format|
      format.json { render :json => @expense_report }
      format.pdf  do
        pdf = ExpenseReportPDF.build(@expense_report)
        send_data pdf.render, type: "application/pdf", disposition: "inline"
      end
    end
  end

  def destroy
    expense_report = ExpenseReport.find(params[:id])
    if expense_report.destroy
      render :json => expense_report, :status => :ok
    else
      render :json => expense_report.errors, :status => 403
    end
  end

  private

  def update_submit_time(expense_report)
    if expense_report.status == "waiting_for_approval"
      expense_report.submitted_at = Time.now
    end
  end

  def safe_params
    params.require(:expense_report).permit(:start_time, :end_time, :country, :currency, :user_id, :status,
      :expenses_attributes => [:description, :amount, :quantity, :exchange_rate, :currency])
  end

  def load_user
    @user = User.find(params[:user_id]) if params[:user_id]
  end

  def load_user_from_respense
    @user = @expense_report.user
  end
end
