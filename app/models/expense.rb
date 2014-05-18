class Expense < ActiveRecord::Base
  belongs_to :expense_report

  def as_json(options = {})
    {
      :description => self.description,
      :amount => self.amount,
      :quantity => self.quantity,
      :currency => self.currency
    }
  end
end
