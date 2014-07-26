module Admin
  class ExpenseReportsController < ApplicationController
    before_action :login_required
    before_action :check_for_list_owner, :only => [:index]

    def index
      @filterrific = Filterrific.new(
        ExpenseReport,
        params[:filterrific] || session[:filterrific_expense_reports]
      )
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




    #def index
      #@status_options  = status_options
      #@user_options    = user_options
      #@expense_reports = ExpenseReport.filter(status, user_id)
    #end

    private

    def status
      params[:status] || 'waiting_for_approval'
    end

    def user_id
      (params[:user_id] == '0') ? nil : params[:user_id]
    end

    def status_options
      ExpenseReport::STATUSES.map {|option| [option, option.humanize, option == params[:status]]}
    end

    def user_options
      User.all.inject([[0, 'All', params[:user_id] == '0']]) do |options, user|
        options << [user.id, user.name, user.id.to_s == params[:user_id]]
      end
    end
  end
end
