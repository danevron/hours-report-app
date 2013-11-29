class Day < ActiveRecord::Base
  belongs_to :timesheet

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
end
