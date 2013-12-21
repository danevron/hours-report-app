class InvitationsController < ApplicationController

  before_action :login_required
  before_action :role_required

  def new
    @invitation = Invitation.new(sender: current_user.email)
  end

  def create
    @invitation = Invitation.new(invitation_params)

    if @invitation.save
      Mailer.delay.invitation_email(@invitation)
      redirect_to current_user, notice: "Your invitation is being sent"
    else
      render "new"
    end
  end

  private

  def invitation_params
    params.require(:invitation).permit(:recipient, :sender, :employee_number)
  end
end
