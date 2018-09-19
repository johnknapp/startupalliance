class RenameLocationToCountry < ActiveRecord::Migration[5.0]
  def change
    rename_column :users, :location, :country_code
    rename_column :companies, :location, :country_code
  end
end
