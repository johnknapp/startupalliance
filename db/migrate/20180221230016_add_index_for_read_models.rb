class AddIndexForReadModels < ActiveRecord::Migration[5.0]
  def change
    add_index :posts, :created_at
  end
end
