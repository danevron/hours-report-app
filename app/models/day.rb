class Day < ActiveRecord::Base
  belongs_to :user_report

  def self.build_days(user_id, from, to)
    (from.to_date..to.to_date).map do |date|
      new(:date => date, :status => "open")
    end
  end

  def weekday
    date.strftime("%A")
  end

  def weekend?
    weekday == "Friday" || weekday == "Saturday"
  end
end
