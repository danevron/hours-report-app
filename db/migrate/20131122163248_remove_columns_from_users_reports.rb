class RemoveColumnsFromUsersReports < ActiveRecord::Migration
  def self.up
    remove_column :users_reports, :date
    remove_column :users_reports, :type
    remove_column :users_reports, :value
    remove_column :users_reports, :status
  end

  def self.down
    add_column :users_reports, :date, :datetime
    add_column :users_reports, :type, :string
    add_column :users_reports, :value, :float
    add_column :users_reports, :status, :string
  end
end
