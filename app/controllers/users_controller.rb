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

  def set_user
    @owner_check_object = @user = User.find_by(:id => params[:id]) || current_user
  end
end
