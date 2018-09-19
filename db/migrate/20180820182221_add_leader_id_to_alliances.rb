class AddLeaderIdToAlliances < ActiveRecord::Migration[5.0]
  def change
    add_column :alliances, :leader_id, :integer
  end
end
