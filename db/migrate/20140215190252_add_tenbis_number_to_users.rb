class AddTenbisNumberToUsers < ActiveRecord::Migration
  def change
    add_column :users, :tenbis_number, :string, :default => ""
  end
end
