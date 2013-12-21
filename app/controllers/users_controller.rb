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
    params['user'].keys.each do |id|
      @user = User.find(id.to_i)
      @user.update_attributes(params['user'][id].permit(:role_id))
    end
    redirect_to(users_url)
  end

  def set_user
    @owner_check_object = @user = User.find_by(:id => params[:id]) || current_user
  end
end
