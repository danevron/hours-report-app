class InvitationsController < ApplicationController

  before_filter :authenticate_user

  def create
    @invitation = Invitation.new(params[:invitation])

    if @invitation.valid?
      Mailer.delay.invitation_email(@invitation)
      redirect_to :back, notice: "Your invitation is being sent"
    else
      redirect_to :back, alert: "Invitation could not be sent"
    end
  end
end
