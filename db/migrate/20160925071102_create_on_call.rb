class CreateOnCall < ActiveRecord::Migration
  def change
    create_table :on_calls do |t|
      t.date :date
      t.string :email
      t.string :schedule

      t.timestamps
    end

    add_index :on_calls, [:date, :schedule], unique: true, name: 'index_on_calls_on_date_and_schedule'
  end
end
