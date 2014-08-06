class ExpenseReport < ActiveRecord::Base
  STATUSES = ['waiting_for_approval', 'approved', 'archived']

  filterrific :filter_names => %w[ with_user_id with_start_time_gte with_status]

  scope :with_user_id, lambda { |user_ids| where(:user_id => [*user_ids]) }
  scope :with_status, lambda { |statuses| where(:status => [*statuses]) }
  scope :with_start_time_gte, lambda { |start_time| where('expense_reports.start_time >= ?', start_time) }

  self.per_page = 30

  belongs_to :user
  has_many :expenses

  validates_datetime :start_time, :end_time
  validates_datetime :end_time, :after => :start_time

  accepts_nested_attributes_for :expenses
  validates_associated :expenses
  validates :status, inclusion: { in: STATUSES }

  delegate :current_timesheet, :to => :user

  after_create :notify_admins
  before_update :attach_to_timesheet, :if => :status_changed?

  scope :approved, -> { where(:status => "approved") }
  scope :for_user, ->(user) { where(:user_id => user.id) }

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

  def archive!
    self.status = 'archived'
    save
  end

  def approve!
    self.status = 'approved'
    save
  end

  def attach_to_timesheet
    if status == 'approved' && current_timesheet
      self.timesheet_id = current_timesheet.id
    end
  end

  def total
    expenses.inject(0) { |sum, expense| sum += expense.total }
  end
end
