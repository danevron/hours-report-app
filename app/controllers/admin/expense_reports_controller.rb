module Admin
  class ExpenseReportsController < ApplicationController
    before_action :login_required
    before_action :check_for_list_owner, :only => [:index]

    def index
      @expense_reports = ExpenseReport.where(status: 'waiting_for_approval')
    end
  end
end