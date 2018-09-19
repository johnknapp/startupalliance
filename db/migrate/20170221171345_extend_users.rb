class ExtendUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :skill_index, :integer, default: 0
    add_column :users, :trait_index, :integer, default: 0
    add_column :users, :company_owner, :boolean, default: false
  end
end
