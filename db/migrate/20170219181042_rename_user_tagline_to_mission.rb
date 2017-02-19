class RenameUserTaglineToMission < ActiveRecord::Migration[5.0]
  def change
    rename_column :users, :tagline, :mission
  end
end
