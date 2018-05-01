class CreateOffers < ActiveRecord::Migration[5.0]
  def change
    create_table :offers do |t|
      t.string      :header_1
      t.string      :header_2
      t.string      :offer_lead_in
      t.text        :plan_benefits
      t.integer     :plan_id
      t.string      :coupon
      t.datetime    :valid_through
      t.string      :pid,                 null: false

      t.timestamps
    end
    add_index   :offers, :pid
  end
end
