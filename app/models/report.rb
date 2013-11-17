class Report < ActiveRecord::Base
  has_and_belongs_to_many :users

  validates :current, uniqueness: true, if: "current?"
  validates_datetime :start_date
  validates_date :end_date, :after => lambda { |report| report.start_date + 1.month }
end
