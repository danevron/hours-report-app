class AddDetailsToDays < ActiveRecord::Migration
  def change
    add_column :days, :type, :string
    add_column :days, :value, :float
    add_column :days, :status, :string
  end
end
