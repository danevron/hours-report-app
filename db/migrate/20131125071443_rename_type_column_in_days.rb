class RenameTypeColumnInDays < ActiveRecord::Migration
  def change
    rename_column :days, :type, :day_type
  end
end
