class RefactorPostsForeignKey < ActiveRecord::Migration[5.0]
  def change
    rename_column :posts, :discussion_id, :topic_id
  end
end
