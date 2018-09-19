class DropInvoices < ActiveRecord::Migration[5.0]
  def up
    drop_table :invoices
  end
  def down
    create_table :invoices do |t|
      t.integer :user_id
      t.integer :plan_id
      t.string  :stripe_subscription_id
      t.integer :stripe_invoice_date
      t.string  :stripe_invoice_id
      t.integer :amount_due
      t.string  :currency
      t.string  :paid

      t.timestamps
    end
  end

end
