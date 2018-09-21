class CreateEvents < ActiveRecord::Migration[5.0]
  def change
    create_table :events do |t|
      t.string :title
      t.string :description
      t.datetime :start_time
      t.integer :type
      t.integer :organizer_id
      t.integer :alliance_id
      t.string :access_url
      t.string :state, default: 'Proposed'
      t.string :pid

      t.timestamps
    end
  end
end
