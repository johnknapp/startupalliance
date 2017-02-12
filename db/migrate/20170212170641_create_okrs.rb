class CreateOkrs < ActiveRecord::Migration[5.0]
  def change
    create_table :okrs do |t|
      t.string :objective
      t.string :key_result_1
      t.string :key_result_2
      t.string :key_result_3
      t.date :period_start
      t.date :period_end
      t.integer :mid_score
      t.integer :final_score
      t.integer :company_id,              null: false
      t.string :state,                                 default: 'initialized'
      t.string :pid,                      null: false

      t.timestamps
    end
  end
end
