class AddCreatorToAlliances < ActiveRecord::Migration[5.0]
  def change
    add_column :alliances, :creator_id, :integer
  end
end
