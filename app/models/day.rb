class Day < ActiveRecord::Base

  DAY_TYPES = %w(workday weekend sickness vacation army)

  belongs_to :timesheet

  validates :day_type, inclusion: { in: DAY_TYPES }, :allow_nil => true
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
    weekday == "Friday" || weekday == "Saturday"
  end

  private

  def prefill_default_values
    if weekend?
      self.day_type = "weekend"
      self.value = 0
    else
      self.day_type = "workday"
      self.value = 9
    end
  end
end
