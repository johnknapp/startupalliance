class RenameDiscussionsTopic < ActiveRecord::Migration[5.0]
  def change
    rename_column :discussions, :topic, :name
  end
end
