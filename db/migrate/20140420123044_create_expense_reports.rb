class CreateExpenseReports < ActiveRecord::Migration
  def change
    create_table :expense_reports do |t|
      t.timestamp :start_time
      t.timestamp :end_time
      t.string :country
      t.string :currency
      t.string :status
      t.references :user, index: true

      t.timestamps
    end
  end
end
