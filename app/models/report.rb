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

  def self.current_report
    find_by(:current => true)
  end

  def add_new_user(user)
    self.timesheets << Timesheet.build_timesheets([user], self.start_date, self.end_date)
  end

  def timesheet_summaries
    timesheets.map do |timesheet|
      summary.new(timesheet.id,
                  timesheet.user_id,
                  timesheet.user_name,
                  timesheet.total_hours,
                  timesheet.vacation_days,
                  timesheet.sickness_days,
                  timesheet.army_reserve_days,
                  timesheet.tenbis,
                  timesheet.status,
                  timesheet.comments)
    end

  end

  private

  def summary
    Struct.new(:id,
               :user_id,
               :user_name,
               :total_hours,
               :vacation_days,
               :sickness_days,
               :army_reserve_days,
               :tenbis,
               :status,
               :comments)
  end
end
