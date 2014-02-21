class Day < ActiveRecord::Base

  DAY_TYPES = %w(workday weekend holiday sickness vacation army)
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

  def weekday
    date.strftime("%A")
  end

  def weekend?
    WEEKEND_DAYS.include?(weekday)
  end

  private

  def prefill_default_values
    if Calendar.holidays[date.to_date]
      self.day_type = "holiday"
      self.comment = Calendar.holidays[date.to_date]
    elsif weekend?
      self.day_type = "weekend"
    else
      self.day_type = "workday"
    end
    self.value = 0
  end
end
