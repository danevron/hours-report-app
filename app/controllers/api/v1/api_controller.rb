class Api::V1::ApiController < ApplicationController
  respond_to :json

  before_filter :set_default_response_format

  protected

  def set_default_response_format
    request.format = :json if params[:format].blank?
  end
end
