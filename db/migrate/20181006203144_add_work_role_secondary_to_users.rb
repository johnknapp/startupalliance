class AddWorkRoleSecondaryToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :work_role_secondary, :string, default: 'Unset'
    rename_column :users, :work_role, :work_role_primary
  end
end
