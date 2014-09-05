class AddSubmittedAtToExpenseReports < ActiveRecord::Migration
  def change
    add_column :expense_reports, :submitted_at, :datetime
  end
end
