class CreateDays < ActiveRecord::Migration
  def change
    create_table :days do |t|
      t.integer :timesheet_id
      t.datetime :date
      t.string :day_type
      t.float :value
      t.string :comment

      t.timestamps
    end
  end
end
