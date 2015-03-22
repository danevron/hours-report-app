class AddDepartmentIdToInvitation < ActiveRecord::Migration
  def change
    add_column :invitations, :department_id, :integer
  end
end
