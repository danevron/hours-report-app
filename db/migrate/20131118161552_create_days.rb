class CreateDays < ActiveRecord::Migration

  class Day < ActiveRecord::Base; end

  def self.up
    rename_table :reports_users, :days
    add_column :days, :id, :primary_key
  end

  def self.down
    remove_column :days, :id
    rename_table :days, :reports_users
  end
end
