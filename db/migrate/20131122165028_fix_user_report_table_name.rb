class FixUserReportTableName < ActiveRecord::Migration

  def self.up
    rename_table :users_reports, :user_reports
  end

  def self.down
    rename_table :user_reports, :users_reports
  end
end
