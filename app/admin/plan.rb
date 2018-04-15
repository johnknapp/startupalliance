ActiveAdmin.register Plan do

  permit_params :name, :amount, :trial_period_days, :stripe_id

  menu parent: 'Subscriptions'

  index do
    selectable_column
    column :id
    column :name
    column :amount
    column :trial_period_days
    column :stripe_id
    actions
  end


  form do |f|
    f.inputs 'Edit Plan' do
      f.input :name
      f.input :amount, hint: 'in cents, $19.95 == 1995'
      f.input :trial_period_days
      f.input :stripe_id, label: 'Stripe ID'
    end
    f.actions
  end

end