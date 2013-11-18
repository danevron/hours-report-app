class AddDateToDays < ActiveRecord::Migration
  def change
    add_column :days, :date, :datetime
    add_index :days, :date
  end
end
