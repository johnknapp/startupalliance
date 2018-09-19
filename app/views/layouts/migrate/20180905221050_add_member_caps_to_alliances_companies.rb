class AddMemberCapsToAlliancesCompanies < ActiveRecord::Migration[5.0]
  def change
    add_column :alliances, :member_cap, :integer, default: 12
    add_column :companies, :member_cap, :integer, default: 24
  end
end
