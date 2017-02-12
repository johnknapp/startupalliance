class CreateAllianceUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :alliance_users do |t|
      t.integer :alliance_id,               null: false
      t.integer :user_id,                   null: false

      t.timestamps
    end
  end
end
