class Api::V1::ExpensesController < Api::V1::ApiController
  inherit_resources

  def index
    @expenses = Expense.where({})
    [:expense_report_id].each do |p|
      if params[p].present?
        @expenses = @expenses.where( p => params[p] )
      end
    end
    render :json => @expenses
  end
end
