class Expense < ActiveRecord::Base
  belongs_to :expense_report

  def as_json(options = {})
    {
      :amount        => self.amount.to_f,
      :currency      => self.currency,
      :description   => self.description,
      :exchange_rate => self.exchange_rate,
      :id            => self.id,
      :quantity      => self.quantity.to_f
    }
  end
end
