class Timesheet < ActiveRecord::Base

  default_scope { order('created_at DESC') }

  belongs_to :user
  belongs_to :report

  has_many :days, dependent: :destroy
  has_many :expense_reports

  validates_associated :days
  validates :status, inclusion: { in: %w(open submitted reopened) }
  validate :report_open, :if => :reopened?
  validate :user_is_active, :if => :reopened?

  accepts_nested_attributes_for :days
  delegate :current?, :start_date, :end_date, :to => :report
  delegate :submitted?, :open?, :reopened?, :to => :status
  delegate :name, :to => :user, :prefix => :user

  attr_reader :calendar_events
  before_save :extract_calendar_events, :if => :calendar_events

  def self.build_timesheets(users, start_date, end_date)
    users.map do |user|
      timesheet = new(:user_id => user.id, :status => "open")
      timesheet.days = Day.build_days(start_date, end_date)
      timesheet.expense_reports = ExpenseReport.for_user(user).approved
      timesheet
    end
  end

  def status
    status = read_attribute(:status) || ''
    status.inquiry
  end

  def total_hours
    summarize("workday")
  end

  def vacation_days
    summarize("vacation")
  end

  def leave_of_absence_days
    summarize("leave_of_absence")
  end

  def army_reserve_days
    summarize("army")
  end

  def sickness_days
    summarize("sickness")
  end

  def tenbis

  end

  def expenses_abroad
    total = expense_reports.inject(0) { |sum, report| sum += report.total }
    total.ceil
  end

  def on_call_compensation
    on_call_days.inject(0) do |sum, day|
      ["holiday", "weekend"].include?(day.day_type) ? sum += 1000 : sum += 500
    end
  end

  def comments_number
    self.days.select { |d| d.comment? }.count + (self.comments? ? 1 : 0)
  end

  def calendar_events=(string_value)
    @calendar_events = (string_value == "1")
  end

  def on_call_days
    days.select { |d| d.on_call }
  end

  private

  def extract_calendar_events
    events = Calendar.personal_events(user.access_token_for_api, user.email, start_date, end_date)
    events.each do |date, title|
      event_day = days.select { |d| d.date.to_s == date.to_s }
      event_day.first.set_personal_calendar_event(title) unless event_day.empty?
    end
  end

  def summarize(day_type)
    days.inject(0) do |sum, day|
      day.day_type == day_type ? sum += day.value : sum
    end
  end

  def report_open
    errors[:base] << "Timesheet cannot be reopened due to submitted report" if self.report.submitted?
  end

  def user_is_active
    errors[:base] << "Timesheet cannot be reopened due to inactive user" if self.user.inactive?
  end
end
