class ChangeDaysTableToUsersReports < ActiveRecord::Migration

  class UserReport < ActiveRecord::Base; end

  def self.up
    rename_table :days, :users_reports
  end

  def self.down
    rename_table :users_reports, :days
  end
end
