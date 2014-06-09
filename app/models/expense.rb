class Expense < ActiveRecord::Base
  belongs_to :expense_report

  def as_json(options = {})
    {
      :amount        => self.amount,
      :currency      => self.currency,
      :description   => self.description,
      :exchange_rate => self.exchange_rate,
      :id            => self.id,
      :quantity      => self.quantity
    }
  end
end
