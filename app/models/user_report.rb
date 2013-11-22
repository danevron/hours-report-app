class UserReport < ActiveRecord::Base
  belongs_to :user
  belongs_to :report

  has_many :days

  after_create :create_days

  private

  def create_days
    binding.pry
    (report.start_date..report.end_date).each do |date|
      binding.pry
      days << Day.create(date: date)
    end
  end
end
