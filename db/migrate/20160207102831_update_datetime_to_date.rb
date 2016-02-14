class UpdateDatetimeToDate < ActiveRecord::Migration
  def up
    change_column :days, :date, :date
    change_column :reports, :start_date, :date
    change_column :reports, :end_date, :date
    change_column :reports, :tenbis_date, :date
    change_column :expense_reports, :start_time, :date
    change_column :expense_reports, :end_time, :date
  end

  def down
    change_column :days, :date, :datetime
    change_column :reports, :start_date, :datetime
    change_column :reports, :end_date, :datetime
    change_column :reports, :tenbis_date, :datetime
    change_column :expense_reports, :start_time, :datetime
    change_column :expense_reports, :end_time, :datetime
  end
end
