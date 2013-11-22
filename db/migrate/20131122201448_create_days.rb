class CreateDays < ActiveRecord::Migration
  def change
    create_table :days do |t|
      t.integer :user_report_id
      t.datetime :date
      t.string :type
      t.float :value
      t.string :comment
      t.string :status

      t.timestamps
    end
  end
end
