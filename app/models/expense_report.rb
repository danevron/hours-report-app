class ExpenseReport < ActiveRecord::Base
  belongs_to :user
  has_many :expenses

  def self.build_report
    expense_report = self.new
    expense_report.expenses << Expense.new_default
    expense_report
  end
end
