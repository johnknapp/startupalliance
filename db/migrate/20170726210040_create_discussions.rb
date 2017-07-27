class CreateDiscussions < ActiveRecord::Migration[5.0]
  def change
    create_table :discussions do |t|
      t.string :title
      t.string :description
      t.references :discussable, polymorphic: true, null: false
      t.string :pid,                                null: false
      t.integer :author_id,                         null: false


      t.timestamps
    end
  end
end
