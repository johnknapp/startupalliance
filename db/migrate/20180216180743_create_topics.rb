class CreateTopics < ActiveRecord::Migration[5.0]
  def change
    create_table :topics do |t|
      t.string :name
      t.integer :discussion_id,     null: false
      t.string :pid,                null: false
      t.integer :author_id,         null: false

      t.timestamps
    end
  end
end
