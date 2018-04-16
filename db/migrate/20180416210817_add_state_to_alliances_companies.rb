class AddStateToAlliancesCompanies < ActiveRecord::Migration[5.0]
  def change
    add_column :alliances, :state, :integer, default: 0
    add_column :companies, :state, :integer, default: 0
  end
end
