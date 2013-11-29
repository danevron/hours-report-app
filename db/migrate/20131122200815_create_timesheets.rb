class CreateTimesheets < ActiveRecord::Migration
  def change
    create_table :timesheets do |t|
      t.integer :user_id
      t.integer :report_id
      t.string :status
      t.text :comments

      t.timestamps
    end
  end
end
