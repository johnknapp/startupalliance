class DropSubscriptionExpiresAtFromUsers < ActiveRecord::Migration[5.0]
  def change
    remove_column :users, :subscription_expires_at, :datetime
  end
end
