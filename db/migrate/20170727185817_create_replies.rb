class CreateReplies < ActiveRecord::Migration[5.0]
  def change
    create_table :replies do |t|
      t.text :body
      t.integer :post_id,               null: false
      t.string  :pid,                   null: false
      t.integer :author_id,             null: false

      t.timestamps
    end
  end
end
