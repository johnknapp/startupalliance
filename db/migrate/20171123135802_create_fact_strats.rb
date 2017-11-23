class CreateFactStrats < ActiveRecord::Migration[5.0]
  def change
    create_table :fact_strats do |t|
      t.integer :factor_id
      t.integer :strategy_id

      t.timestamps
    end
  end
end
