class Report < ActiveRecord::Base
  has_many :timesheets, dependent: :destroy
  has_many :reminders, dependent: :destroy
  has_many :users, :through => :timesheets
  has_many :expense_reports, :through => :timesheets

  validates :current, uniqueness: true, if: "current?"
  validates_datetime :start_date
  validates_date :end_date, :after => lambda { |report| report.start_date + 1.month - 2.days }

  validates :status, inclusion: { in: %w(open submitted reopened) }
  validates_associated :timesheets
  validates :start_date, :end_date,
    :overlap => { :message_title => :overlapping,
                  :message_content => "There is an overalapping report for the given dates" }
  validate :timesheets_submitted, :if => :submitted?

  scope :unsubmitted, -> { where.not(:status => "submitted") }

  after_create :extract_tenbis_usage
  after_update :archive_expense_reports, :if => :status_changed?

  delegate :submitted?, :open?, :reopened?, :to => :status

  def self.build_report(report_data)
    report = new(report_data)
    if report.start_date && report.end_date
      report.tenbis_date = Date.parse report_data["tenbis_date"]
      report.timesheets = Timesheet.build_timesheets(
        User.active, report.start_date, report.end_date
      )
    end
    report
  end

  def self.current_report
    find_by(:current => true)
  end

  def self.prepare_next
    if Report.not_first?
      Report.new(:start_date => last_end_date + 1.day, :end_date => last_end_date + 1.month, :tenbis_date => last_tenbis_date + 1.month)
    else
      Report.new
    end
  end

  def self.last_end_date
    Report.order(:end_date => :desc).first.end_date
  end

  def self.last_tenbis_date
    Report.order(:tenbis_date => :desc).first.tenbis_date
  end

  def add_new_user(user)
    self.timesheets << Timesheet.build_timesheets([user], self.start_date, self.end_date)
    TenbisUsageCollector.perform_in(2.minutes, self.id)
  end

  def archive_expense_reports
    if submitted?
      self.expense_reports.each(&:archive!)
    elsif reopened?
      self.expense_reports.each(&:approve!)
    end
  end

  def timesheet_summaries
    timesheets.joins(:user).order("users.employee_number").map do |timesheet|
      summary.new(timesheet.id,
                  timesheet.user_id,
                  timesheet.user_name,
                  timesheet.user.employee_number,
                  timesheet.total_hours,
                  timesheet.vacation_days,
                  timesheet.sickness_days,
                  timesheet.army_reserve_days,
                  timesheet.tenbis_usage,
                  timesheet.expenses_abroad,
                  timesheet.status,
                  timesheet.comments_number)
    end

  end

  def status
    status = read_attribute(:status) || ''
    status.inquiry
  end

  private

  def self.not_first?
    Report.count > 0
  end

  def summary
    Struct.new(:id,
               :user_id,
               :user_name,
               :employee_number,
               :total_hours,
               :vacation_days,
               :sickness_days,
               :army_reserve_days,
               :tenbis,
               :expenses_abroad,
               :status,
               :comments_number)
  end

  def extract_tenbis_usage
    TenbisWorker.perform_async(self.tenbis_date.month, self.tenbis_date.year)
    TenbisUsageCollector.perform_in(2.minutes, self.id)
  end

  def timesheets_submitted
    self.timesheets.each do |timesheet|
      return errors[:base] << "Report cannot be submitted due to unsubmitted timesheets" unless timesheet.submitted?
    end
  end
end
