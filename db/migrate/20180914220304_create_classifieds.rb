class CreateClassifieds < ActiveRecord::Migration[5.0]
  def change
    create_table :classifieds do |t|
      t.string :title
      t.string :body
      t.string :creator_id
      t.string :pid

      t.timestamps
    end
  end
end
