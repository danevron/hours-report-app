class AddTenBisUsageToTimesheets < ActiveRecord::Migration
  def change
    add_column :timesheets, :tenbis_usage, :float
  end
end
