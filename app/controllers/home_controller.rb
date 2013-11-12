class HomeController < ApplicationController

  before_action :authenticate_user

  def index
    @invitation = Invitation.new
  end
end
