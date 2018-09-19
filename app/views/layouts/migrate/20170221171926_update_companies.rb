class UpdateCompanies < ActiveRecord::Migration[5.0]
  def change
    rename_column :companies, :offering,  :description
    rename_column :companies, :serving,   :primary_market
  end
end
