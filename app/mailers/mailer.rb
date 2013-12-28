class Mailer < ActionMailer::Base

  def invitation_email(invitation)

    @invitation = invitation

    mail(
      from: "Hours Report <noreply@hoursreport.se>",
      to: @invitation.recipient_named_email,
      subject: "Welcome to Hours Report"
    )
  end

  def reminder_email(user_id, report_id)

    @user = User.find(user_id)
    @report = Report.find(report_id)

    mail(
      from: "Hours Report <noreply@hoursreport.se>",
      to: @user.email,
      subject: "Please fill your Hours Report"
    )
  end
end
