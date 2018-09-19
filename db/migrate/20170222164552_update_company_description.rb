class UpdateCompanyDescription < ActiveRecord::Migration[5.0]
  def up
    change_column :companies, :description, :text
  end
  def down
    change_column :companies, :description, :string
  end
end
