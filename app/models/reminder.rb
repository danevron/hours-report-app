class Reminder < ActiveRecord::Base
  belongs_to :report

  after_create :send_reminder_emails

  def send_reminder_emails
    self.report.users.each do |user|
      Mailer.delay.reminder_email(user.id, self.report.id) unless self.report.timesheets.find_by_user_id(user.id).status == "submitted"
    end
  end

end
