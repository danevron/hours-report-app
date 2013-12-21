class AddEmployeeNumberToInvitations < ActiveRecord::Migration
  def change
    add_column :invitations, :employee_number, :integer
  end
end
