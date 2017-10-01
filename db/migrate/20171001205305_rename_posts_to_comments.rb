class RenamePostsToComments < ActiveRecord::Migration[5.0]
  def change
    rename_table :posts, :comments
  end
end
