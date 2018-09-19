class AddStateToPlans < ActiveRecord::Migration[5.0]
  def change
    add_column :plans, :state, :string, default: 'active'
  end
end
