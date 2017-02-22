class AddCreatorToCompanies < ActiveRecord::Migration[5.0]
  def change
    add_column :companies, :creator_id, :integer
  end
end
