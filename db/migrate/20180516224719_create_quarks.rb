class CreateQuarks < ActiveRecord::Migration[5.0]
  def change
    create_table :quarks do |t|
      t.string :text
      t.integer :author_id
      t.string :state,                        default: 'Suggestion'
      t.string :pid,          null: false

      t.timestamps
    end
  end
end
