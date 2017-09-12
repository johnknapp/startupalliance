class AddInviteTokens < ActiveRecord::Migration[5.0]
  def change
    add_column :companies, :invite_token, :string
    add_column :alliances, :invite_token, :string
  end
end
