class AddQuarksCountToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :quarks_count, :integer, default: 0, null: false
  end
end
