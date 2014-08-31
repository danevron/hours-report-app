module Admin
  class ExpenseReportsController < ApplicationController
    before_action :login_required
    before_action :check_for_list_owner, :only => [:index]

    def index
      @filterrific = Filterrific.new(
        ExpenseReport,
        params[:filterrific] || session[:filterrific_expense_reports]
      )

      @filterrific.select_options = {
        with_status: ExpenseReport.options_for_select,
        with_user_id: User.all.map { |user| [user.name, user.id] }
      }

      @expense_reports = ExpenseReport.filterrific_find(@filterrific).page(params[:page])
      session[:filterrific_expense_reports] = @filterrific.to_hash

      respond_to do |format|
        format.html
        format.js
      end
    end

    def reset_filterrific
      session[:filterrific_expense_reports] = nil
      redirect_to :action => :index
    end

  end
end
