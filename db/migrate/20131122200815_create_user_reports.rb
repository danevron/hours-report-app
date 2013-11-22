class CreateUserReports < ActiveRecord::Migration
  def change
    create_table :user_reports do |t|
      t.integer :user_id
      t.integer :report_id
      t.text :comments

      t.timestamps
    end
  end
end
