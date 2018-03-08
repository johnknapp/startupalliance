class AddWorkRoleToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :work_role, :string, default: 'Unset'
  end
end
