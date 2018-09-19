class AddDisplayNameToPlans < ActiveRecord::Migration[5.0]
  def change
    add_column :plans, :display_name, :string
  end
end
