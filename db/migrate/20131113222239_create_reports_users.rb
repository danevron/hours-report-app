class CreateReportsUsers < ActiveRecord::Migration
  def change
    create_table :reports_users, :id => false do |t|
      t.references :report
      t.references :user
    end
    add_index :reports_users, [:report_id, :user_id]
    add_index :reports_users, :user_id
  end
end
