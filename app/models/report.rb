class Report < ActiveRecord::Base
  has_many :timesheets, dependent: :destroy
  has_many :users, :through => :timesheets

  validates :current, uniqueness: true, if: "current?"
  validates_datetime :start_date
  validates_date :end_date, :after => lambda { |report| report.start_date + 1.month - 2.days }

  validates_associated :timesheets
  validates :start_date, :end_date,
    :overlap => { :message_title => :overlapping,
                  :message_content => "There is an overalapping report for the given dates" }


  def self.build_report(report_data)
    report = new(report_data)
    report.timesheets = Timesheet.build_timesheets(User.active_users, report.start_date, report.end_date) if report.start_date && report.end_date
    report
  end
end
