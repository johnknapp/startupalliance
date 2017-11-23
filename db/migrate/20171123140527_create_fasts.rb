class CreateFasts < ActiveRecord::Migration[5.0]
  def change
    create_table :fasts do |t|
      t.string  :body
      t.boolean :is_factor
      t.integer :company_id
      t.integer :user_id
      t.string  :pid,                      null: false

      t.timestamps
    end
    add_index :fasts, :company_id
    add_index :fasts, :user_id
  end
end
