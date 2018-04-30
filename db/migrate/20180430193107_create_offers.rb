class CreateOffers < ActiveRecord::Migration[5.0]
  def change
    create_table :offers do |t|
      t.string      :audience
      t.string      :blurb
      t.text        :features
      t.integer     :plan_id
      t.string      :coupon
      t.datetime    :valid_through
      t.string      :pid,                 null: false

      t.timestamps
    end
    add_index   :offers, :pid
  end
end
