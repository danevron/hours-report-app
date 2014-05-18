class Api::V1::ExpenseReportsController < Api::V1::ApiController
  inherit_resources

  def index
    @expense_reports = ExpenseReport.joins(:expenses).where({})
    [:user_id].each do |p|
      if params[p].present?
        @expense_reports = @expense_reports.where( p => params[p] )
      end
    end
    render :json => @expense_reports
  end
end
