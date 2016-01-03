class Api::V2::TimesheetsController < ActionController::Base
  http_basic_authenticate_with :name => ENV['API_V2_USER'], :password => ENV['API_V2_PASSWORD']
  respond_to :json

  def current_timesheet
    user = User.find_by(email: params[:email])

    if user && user.current_timesheet
      render :json => user.current_timesheet, :status => :ok
    else
      render :json => { error: "not-found" }.to_json, :status => :not_found
    end
  end

  protected

  def set_default_response_format
    request.format = :json if params[:format].blank?
  end
end
