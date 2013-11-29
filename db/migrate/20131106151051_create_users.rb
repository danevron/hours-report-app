class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :provider
      t.string :uid
      t.string :first_name
      t.string :last_name
      t.string :refresh_token
      t.string :access_token
      t.timestamp :expires
      t.string :email
      t.string :image
      t.string :status, :null => false, :default => "active"


      t.timestamps
    end
  end
end
