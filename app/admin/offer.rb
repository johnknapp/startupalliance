ActiveAdmin.register Offer do

  permit_params :audience, :blurb, :features, :plan_id, :coupon, :valid_through

  menu parent: 'Subscriptions'

  controller do
    def find_resource
      scoped_collection.where(pid: params[:id]).first!
    end
  end

  form do |f|
    f.inputs 'Edit Offer' do
      f.input :audience
      f.input :blurb
      f.input :features, input_html: { rows: 10 }, hint: 'Markdown supported'
      f.input :plan_id, as: :select, collection: Plan.all.order(:display_name).pluck(:display_name, :id), include_blank: 'Choose plan'
      f.input :coupon, hint: 'Must be currently valid code'
      f.input :valid_through
    end
    f.actions
  end

end