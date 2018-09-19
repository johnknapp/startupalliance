class AddSoftDeleteToTheDisco < ActiveRecord::Migration[5.0]
  def change
    add_column  :discussions, :deleted_at, :datetime
    add_index   :discussions, :deleted_at
    add_column  :topics,      :deleted_at, :datetime
    add_index   :topics,      :deleted_at
    add_column  :posts,       :deleted_at, :datetime
    add_index   :posts,       :deleted_at
  end
end
