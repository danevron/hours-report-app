class CreateTenbis < ActiveRecord::Migration
  def change
    create_table :tenbis do |t|
      t.datetime :date
      t.text :usage

      t.timestamps
    end
  end
end
