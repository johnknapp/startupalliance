class CreateCompanies < ActiveRecord::Migration[5.0]
  def change
    create_table :companies do |t|
      t.string :name
      t.string :offering
      t.string :serving
      t.string :url
      t.string :location
      t.string :latitude
      t.string :longitude
      t.string :time_zone
      t.date   :founded
      t.string :state,                                 default: 'initialized'
      t.string :pid,                      null: false

      t.timestamps
    end
  end
end
