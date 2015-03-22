class UsersController < ApplicationController

  before_action :login_required
  before_action :role_required, :only => [:index]
  before_action :set_user, :only => [:show]
  before_action :owner_required, :only => [:show]

  def index
    @users = User.all
  end

  def show
  end

  def update_all
    @users = []
    errors_found = false
    params['user'].keys.each do |id|
      @user = User.find(id.to_i)
      @user.update_attributes(params['user'][id].permit(:role_id, :status, :employee_number, :tenbis_number, :department_id))
      @users << @user
      errors_found = true unless @user.valid?
    end
    if errors_found
      flash[:alert] = "Some errors were found"
    else
      flash[:notice] = "Users saved"
    end
    render 'index'
  end

  def set_user
    @owner_check_object = @user = User.find_by(:id => params[:id]) || current_user
  end
end
