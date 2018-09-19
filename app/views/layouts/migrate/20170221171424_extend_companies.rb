class ExtendCompanies < ActiveRecord::Migration[5.0]
  def change
    add_column :companies, :sakpi_index, :integer, default: 0
  end
end
