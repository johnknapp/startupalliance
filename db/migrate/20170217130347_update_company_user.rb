class UpdateCompanyUser < ActiveRecord::Migration[5.0]
  def change
    add_column :company_users, :role, :integer, default: 0
    rename_column :company_users, :share, :equity
  end
end
