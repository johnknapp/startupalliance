ActiveAdmin.register Prospect do

  permit_params :email, :acqsrc, :offer_id, :subscribed

  menu parent: 'Subscriptions'

end