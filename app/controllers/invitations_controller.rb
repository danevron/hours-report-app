class InvitationsController < ApplicationController

  before_filter :authenticate_user

  def new
    @invitation = Invitation.new(sender: current_user.email)
  end

  def create
    @invitation = Invitation.new(params[:invitation])

    if @invitation.valid?
      Mailer.delay.invitation_email(@invitation)
      redirect_to root_path, notice: "Your invitation is being sent"
    else
      render "new"
    end
  end
end
