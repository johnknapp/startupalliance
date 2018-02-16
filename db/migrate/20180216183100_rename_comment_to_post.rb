class RenameCommentToPost < ActiveRecord::Migration[5.0]
  def change
    rename_table :comments, :posts
  end
end
