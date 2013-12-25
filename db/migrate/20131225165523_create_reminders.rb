class CreateReminders < ActiveRecord::Migration
  def change
    create_table :reminders do |t|
      t.integer :report_id

      t.timestamps
    end
  end
end
