class Day < ActiveRecord::Base
  belongs_to :timesheet

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
      self.day_type = "work_day"
      self.value = 9
    end
  end
end
