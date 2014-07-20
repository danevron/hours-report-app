class AddTimesheetIdToExpenseReports < ActiveRecord::Migration
  def change
    add_column :expense_reports, :timesheet_id, :integer
  end
end
