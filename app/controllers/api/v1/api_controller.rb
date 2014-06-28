class Api::V1::ApiController < ApplicationController
  respond_to :json

  before_action :set_default_response_format
  before_action :login_required

  protected

  def set_default_response_format
    request.format = :json if params[:format].blank?
  end

  def authenticate_user
    head :unauthorized unless current_user
  end

  def access_denied
    head :forbidden
  end
end
