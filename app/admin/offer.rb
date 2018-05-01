ActiveAdmin.register Offer do

  permit_params :header_1, :header_2, :offer_lead_in, :plan_benefits, :plan_id, :coupon, :valid_through

  menu parent: 'Subscriptions'

  controller do
    def find_resource
      scoped_collection.where(pid: params[:id]).first!
    end
  end

  form do |f|
    f.inputs 'Edit Offer' do
      f.input :header_1, hint: 'Required'
      f.input :header_2, hint: 'Required'
      f.input :offer_lead_in, hint: 'Optional'
      f.input :plan_benefits, input_html: { rows: 10 }, hint: 'Required. Markdown supported.'
      f.input :plan_id, as: :select, hint: 'Required', collection: Plan.all.order(:display_name).pluck(:display_name, :id), include_blank: 'Choose plan'
      f.input :coupon, hint: 'Required. Must be currently valid code'
      f.input :valid_through, hint: 'Required'
    end
    f.actions
  end

end