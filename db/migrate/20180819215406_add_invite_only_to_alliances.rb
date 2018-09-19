class AddInviteOnlyToAlliances < ActiveRecord::Migration[5.0]
  def change
    add_column :alliances, :invite_only, :boolean, default: :false
  end
end
