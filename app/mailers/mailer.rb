class Mailer < ActionMailer::Base

  def invitation_email(invitation)

    @invitation = invitation

    mail(
      to: @invitation.recipient_named_email,
      subject: "Welcome to Hours Report"
    )
  end

  def reminder_email(user_id, report_id)

    @user = User.find(user_id)
    @report = Report.find(report_id)
    @timesheet = @report.timesheets.find_by_user_id(user_id)

    mail(
      to: @user.email,
      subject: "Please fill your Hours Report"
    )
  end

  def expense_report_submitted_email(submitter_user_id, admin_user_id)
    @submitter = User.find(submitter_user_id)
    @admin = User.find(admin_user_id)

    mail(
      to: @admin.email,
      subject: "New expense report submitted"
    )
  end
end
