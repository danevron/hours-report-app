class ExpenseReport < ActiveRecord::Base
  belongs_to :user
  has_many :expenses

  validates_datetime :start_time, :end_time
  validates_datetime :end_time, :after => :start_time

    validates_associated :expenses

  def as_json(options = {})
    {
      :start_time => self.start_time,
      :end_time   => self.end_time,
      :user_id    => self.user_id,
      :currency   => self.currency,
      :country    => self.country,
      :status     => self.status,
      :expenses   => self.expenses
    }
  end
end
