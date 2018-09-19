class AddDisplayPriceToPlans < ActiveRecord::Migration[5.0]
  def change
    add_column :plans, :display_price, :string
  end
end
