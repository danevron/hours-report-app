class Api::V1::ExpenseReportsController < Api::V1::ApiController
  inherit_resources

  def create
  end

  def index
    @expense_reports = ExpenseReport.joins(:expenses).where({})
    [:user_id].each do |p|
      if params[p].present?
        @expense_reports = @expense_reports.where( p => params[p] )
      end
    end
    render :json => @expense_reports
  end

  private

  def safe_params
    params.require(:expense_report).permit(:start_time, :end_time, :country, :currency,
      :expenses_attributes => [:description, :amount, :quantity, :exchange_rate, :currency])
  end
end
