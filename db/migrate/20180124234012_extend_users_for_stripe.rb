class ExtendUsersForStripe < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :stripe_customer_id,       :string
    add_column :users, :plan_id,                  :integer
    add_column :users, :subscribed_at,            :datetime
    add_column :users, :subscription_expires_at,  :datetime
    add_column :users, :subscription_state,       :string
    add_column :users, :stripe_coupon_code,       :string
  end
end
