class RefactorDiscussions < ActiveRecord::Migration[5.0]
  def change
    remove_column :discussions, :description, :text
    rename_column :discussions, :title, :topic
  end
end
