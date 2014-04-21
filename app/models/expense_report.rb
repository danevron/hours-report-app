class ExpenseReport < ActiveRecord::Base
  belongs_to :user
  has_many :expenses

  validates_datetime :start_time, :end_time
  validates_datetime :end_time, :after => :start_time

  validates :start_time, :end_time,
    :overlap => { :message_title => :overlapping,
                  :message_content => "There is an overalapping report for the given interval" }

  validates_associated :expenses
  def self.build_report
    expense_report = self.new
    expense_report.expenses << Expense.new_default
    expense_report
  end
end
