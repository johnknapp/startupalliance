class CreatePageSakpis < ActiveRecord::Migration[5.0]
  def change
    create_table :page_sakpis do |t|
      t.integer :page_id
      t.integer :sakip_id

      t.timestamps
    end
  end
end
