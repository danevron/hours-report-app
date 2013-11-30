class Timesheet < ActiveRecord::Base
  belongs_to :user
  belongs_to :report

  has_many :days, dependent: :destroy
  validates_associated :days
  accepts_nested_attributes_for :days
  delegate :current?, :to => :report
  delegate :submitted?, :open?, :reopened?, :to => :status

  def self.build_timesheets(users, start_date, end_date)
    users.map do |user|
      timesheet = new(:user_id => user.id, :status => "open")
      timesheet.days = Day.build_days(start_date, end_date)
      timesheet
    end
  end

  def status
    status = read_attribute(:status) || ''
    status.inquiry
  end

  def submit!
    update_attributes(:status => "submitted")
  end

  def reopen!
    update_attributes(:status => "reopened")
  end
end
