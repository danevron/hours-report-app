class ApplicationController < ActionController::Base
  include TheRole::Controller

  protect_from_forgery with: :exception

  helper_method :current_user

  def access_denied
    flash[:alert] = 'You are not authorized to view this page!'
    redirect_to_back_or_default
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

  def redirect_to_back_or_default(default = root_url)
    if request.env["HTTP_REFERER"].present? and request.env["HTTP_REFERER"] != request.env["REQUEST_URI"]
      redirect_to :back
    else
      redirect_to default
    end
  end
end
