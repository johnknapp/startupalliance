class AddPlanToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :plan, :string, default: 'associate'
  end
end
