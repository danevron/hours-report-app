class ExpenseReport < ActiveRecord::Base
  belongs_to :user
  has_many :expenses

  validates_datetime :start_time, :end_time
  validates_datetime :end_time, :after => :start_time

  accepts_nested_attributes_for :expenses
  validates_associated :expenses
  validates :status, inclusion: { in: %w(waiting_for_approval approved archived) }

  after_create :notify_admins

  def as_json(options = {})
    {
      :country    => self.country,
      :currency   => self.currency,
      :end_time   => self.end_time,
      :expenses   => self.expenses,
      :id         => self.id,
      :start_time => self.start_time,
      :status     => self.status,
      :user_id    => self.user_id
    }
  end

  def notify_admins
    User.admins.each do |admin|
      Mailer.delay.expense_report_submitted_email(self.user_id, admin.id)
    end
  end
end
