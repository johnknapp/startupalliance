class CreateFactStrats < ActiveRecord::Migration[5.0]
  def change
    create_table :fact_strats do |t|
      t.integer :fast_id
      t.integer :strategy_id

      t.index [:fast_id, :strategy_id], unique: true
    end
  end
end
