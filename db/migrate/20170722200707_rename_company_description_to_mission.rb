class RenameCompanyDescriptionToMission < ActiveRecord::Migration[5.0]
  def change
    rename_column :companies, :description, :mission
  end
end
