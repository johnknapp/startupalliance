class CreateAlliances < ActiveRecord::Migration[5.0]
  def change
    create_table :alliances do |t|
      t.string :name
      t.string :purpose
      t.string :webmeet_url
      t.string :state,                                 default: 'initialized'
      t.string :pid,                      null: false

      t.timestamps
    end
  end
end
