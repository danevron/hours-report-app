class AddPurchasedAtToExpenses < ActiveRecord::Migration
  def change
    add_column :expenses, :purchased_at, :datetime
  end
end
