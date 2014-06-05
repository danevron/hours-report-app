class AddExchangeRateToExpenses < ActiveRecord::Migration
  def change
    add_column :expenses, :exchange_rate, :decimal
  end
end
