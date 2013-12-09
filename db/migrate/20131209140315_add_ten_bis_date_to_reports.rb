class AddTenBisDateToReports < ActiveRecord::Migration
  def change
    add_column :reports, :tenbis_date, :detatime
  end
end
