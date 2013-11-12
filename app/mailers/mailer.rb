class Mailer < ActionMailer::Base

  def invitation_email(invitation)

    @invitation = invitation

    mail(
      from: @invitation.sender,
      to: @invitation.recipient_named_email,
      subject: "Welcome to Hours Report"
    )
  end
end
