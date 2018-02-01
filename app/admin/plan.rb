ActiveAdmin.register Plan do

  permit_params :name, :amount, :stripe_id

  menu parent: 'Subscriptions'

  index do
    selectable_column
    column :id
    column :name
    column :amount
    column :stripe
    actions
  end


  form do |f|
    f.inputs 'Edit Plan' do
      f.input :name
      f.input :amount, hint: 'in cents, $19.95 == 1995'
      f.input :stripe_id, label: 'Stripe ID'
    end
    f.actions
  end

end