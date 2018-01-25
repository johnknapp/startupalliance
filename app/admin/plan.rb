ActiveAdmin.register Plan do
  menu parent: 'Subscribers'

  form do |f|
    f.inputs 'Edit Plan' do
      f.input :name
      f.input :amount
      f.input :stripe_id
    end
    f.actions
  end

end