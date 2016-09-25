class AddOnCallToDays < ActiveRecord::Migration
  def change
    add_column :days, :on_call, :boolean, default: false
  end
end
