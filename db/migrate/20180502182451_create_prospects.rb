class CreateProspects < ActiveRecord::Migration[5.0]
  def change
    create_table :prospects do |t|
      t.string  :email
      t.string  :acqsrc
      t.integer :offer_id
      t.boolean :subscribed, default: true

      t.timestamps
    end
  end
end
