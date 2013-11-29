class Timesheet < ActiveRecord::Base
  belongs_to :user
  belongs_to :report

  has_many :days, dependent: :destroy
  validates_associated :days
  accepts_nested_attributes_for :days
  delegate :current?, :to => :report

  def self.build_timesheet(user_id, start_date, end_date)
    timesheet = new(:user_id => user_id, :status => "open")
    timesheet.days = Day.build_days(user_id, start_date, end_date)
    timesheet
  end
end
