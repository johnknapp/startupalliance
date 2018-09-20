class AddBox3ToOffers < ActiveRecord::Migration[5.0]
  def change
    add_column :offers, :box_3, :text
  end
end
