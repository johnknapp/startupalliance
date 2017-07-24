class EnableUnlistedCompaniesAndAlliances < ActiveRecord::Migration[5.0]
  def change
    add_column :alliances, :is_unlisted, :boolean, default: false
    add_column :companies, :is_unlisted, :boolean, default: false
  end
end
