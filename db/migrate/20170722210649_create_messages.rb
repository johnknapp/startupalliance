class CreateMessages < ActiveRecord::Migration[5.0]
  def change
    create_table :messages do |t|
      t.text :body
      t.references :conversation, index: true
      t.references :user, index: true
      t.boolean :is_read, default: false
      t.string :pid, null: false

      t.timestamps
    end
  end
end
