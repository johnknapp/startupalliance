ActiveAdmin.register Offer do

  permit_params :pid, :header_1, :header_2, :offer_lead_in, :plan_benefits, :plan_id, :coupon, :valid_through

  menu parent: 'Subscriptions'

  controller do
    def find_resource
      scoped_collection.where(pid: params[:id]).first!
    end
  end

  index do
    selectable_column
    column :landing do |offer|
      link_to offer.pid, offer_path(offer.pid), target: '_blank'
    end
    column :header_1
    column :header_2
    column :offer_lead_in
    column :plan
    column :coupon
    column :valid_through
    actions
  end

  filter :header_1
  filter :header_2
  filter :plan, collection: Plan.all
  filter :valid_through

  form do |f|
    f.inputs 'Edit Offer' do
      f.input :pid, label: 'Landing page code', hint: 'Required. Must be unique. Recommend keep system value.'
      f.input :header_1, hint: 'Required'
      f.input :header_2, hint: 'Required'
      f.input :offer_lead_in, hint: 'Optional'
      f.input :plan_id, as: :select, hint: 'Leave blank for prospect offer.', collection: Plan.all.order(:display_name).pluck(:display_name, :id), include_blank: 'Choose plan'
      f.input :plan_benefits, input_html: { rows: 6 }, hint: 'Required. Markdown supported.'
      f.input :coupon, hint: 'Optional. Must be currently valid code'
      f.input :valid_through, hint: 'Required'
    end
    f.actions
  end

  show do
    attributes_table do
      row :landing_page do |offer|
        link_to offer_url(offer.pid), offer_path(offer.pid), target: '_blank'
      end
      row :header_1
      row :header_2
      row :offer_lead_in
      row :plan
      if offer.plan.present?
        row :plan_detail do |offer|
          "Regular price #{offer.plan.display_price} with #{offer.plan.trial_period_days} day trial"
        end
      end
      if offer.coupon.present?
        row :coupon_detail do |offer|
          coupon = Stripe::Coupon.retrieve(offer.coupon)
          if coupon.percent_off
            "#{coupon.id}: #{coupon.percent_off}% off for #{coupon.duration_in_months} months"
          else
            "#{coupon.id}: #{coupon.amount_off}% off for #{coupon.duration_in_months} months"
          end
        end
      else
        row :coupon_detail do |offer|
          "No coupon on this offer"
        end
      end
      row :offer_valid_through do |offer|
        offer.valid_through
      end
      if offer.plan.present?
        row :benefit_lead_in do |offer|
          "With #{offer.plan.display_name} you can:"
        end
      end
      row :plan_benefits do |offer|
        markdown offer.plan_benefits
      end
    end
  end

    end