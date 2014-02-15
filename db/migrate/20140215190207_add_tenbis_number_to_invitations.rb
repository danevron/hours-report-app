class AddTenbisNumberToInvitations < ActiveRecord::Migration
  def change
    add_column :invitations, :tenbis_number, :string, :default => ""
  end
end
