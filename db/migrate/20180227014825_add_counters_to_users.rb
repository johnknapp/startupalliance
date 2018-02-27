class AddCountersToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :pages_count, :integer, default: 0, null: false
    add_column :users, :posts_count, :integer, default: 0, null: false
    add_column :users, :topics_count, :integer, default: 0, null: false
  end
end
