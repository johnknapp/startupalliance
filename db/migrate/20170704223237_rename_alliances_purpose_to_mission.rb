class RenameAlliancesPurposeToMission < ActiveRecord::Migration[5.0]
  def change
    rename_column :alliances, :purpose, :mission
  end
end
