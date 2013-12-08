class InvitationsController < ApplicationController

  before_filter :authenticate_user

  def new
    @invitation = Invitation.new(sender: current_user.email)
  end

  def create
    @invitation = Invitation.new(invitation_params)

    if @invitation.save
      Mailer.delay.invitation_email(@invitation)
      redirect_to root_path, notice: "Your invitation is being sent"
    else
      render "new"
    end
  end

  private

  def invitation_params
    params.require(:invitation).permit(:recipient, :sender)
  end
end
