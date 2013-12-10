class ApplicationController < ActionController::Base
  include TheRoleController

  protect_from_forgery with: :exception

  helper_method :current_user

  def access_denied
    return render(text: 'access_denied: requires a role')
  end

  alias_method :role_access_denied, :access_denied

  def login_required
    authenticate_user
  end
  private

  def authenticate_user
    redirect_to login_path unless current_user
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
end
