class CreateExpenses < ActiveRecord::Migration
  def change
    create_table :expenses do |t|
      t.string :description
      t.decimal :amount
      t.decimal :quantity
      t.string :currency
      t.references :expense_report, index: true

      t.timestamps
    end
  end
end
