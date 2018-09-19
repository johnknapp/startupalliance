class CreateCompanySakpis < ActiveRecord::Migration[5.0]
  def change
    create_table :company_sakpis do |t|
      t.integer :company_id
      t.integer :sakpi_id
      t.integer :level

      t.timestamps
    end
  end
end
