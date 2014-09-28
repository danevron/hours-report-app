class Day < ActiveRecord::Base

  PERSONAL_CALENDAR_EVENTS_MAPPING = {
    /.*Half PTO.*/ => { :type => "vacation", :value => 0.5 },
    /.*PTO.*/      => { :type => "vacation", :value => 1 },
    /.*Army.*/     => { :type => "army", :value => 1 },
    /.*Sick.*/     => { :type => "sickness", :value => 1 },
    /.*LOA.*/      =>  { :type => "leave_of_absence", :value => 1 }
  }

  DAY_TYPES = %w(workday weekend holiday sickness vacation army leave_of_absence)
  WEEKEND_DAYS = %w(Friday Saturday)

  belongs_to :timesheet

  validates :day_type, inclusion: { in: DAY_TYPES }, :allow_nil => true
  validates_presence_of :value, :on => :update
  before_create :prefill_default_values

  def self.build_days(from, to)
    (from.to_date..to.to_date).map do |date|
      new(:date => date)
    end
  end

  def set_personal_calendar_event(event)
    PERSONAL_CALENDAR_EVENTS_MAPPING.each do |regex, mapping|
      if event =~ regex && self.workday?
        self.day_type = mapping[:type]
        self.value = mapping[:value]
        save
        break
      end
    end
    true
  end

  def workday?
    day_type == "workday"
  end

  def weekday
    date.strftime("%A")
  end

  def weekend?
    WEEKEND_DAYS.include?(weekday)
  end

  private

  def prefill_default_values
    holidays = Calendar.holidays_between(timesheet.start_date, timesheet.end_date)

    if holidays[date.to_date]
      self.day_type = "holiday"
      self.comment = holidays[date.to_date]
    elsif weekend?
      self.day_type = "weekend"
    else
      self.day_type = "workday"
    end
    self.value = 0
  end
end
