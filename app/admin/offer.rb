ActiveAdmin.register Offer do

  permit_params :pid, :header_1, :header_2, :offer_lead_in, :benefit_lead_in, :box_1, :box_2, :box_3, :plan_id, :video_url, :cta_button_text, :coupon, :valid_through

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
    # column :offer_lead_in
    # column :benefit_lead_in
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
      f.li "<h2><strong>Lead-in header stripe for this cohort</strong></h2>".html_safe
      f.input :header_1, hint: 'Required. "Exclusive offer for <cohort name>"'
      f.input :header_2, hint: 'Required. Narrative offer description'
      f.li "<h2><strong>Introduction for this cohort</strong></h2>".html_safe
      f.input :box_1, input_html: { rows: 6 }, hint: 'Introduction. Aligned center.'
      f.input :video_url, label: 'YouTube video code', hint: 'Optional'
      f.li "<h2><strong>Introducing the offer to the cohort</strong></h2>".html_safe
      f.input :offer_lead_in, hint: 'Required'
      f.li "<h2><strong>Plan, Duration, Coupon</strong></h2>".html_safe
      f.input :plan_id, as: :select, hint: 'Required', collection: Plan.where(state: 'active').order(:display_name).pluck(:display_name, :id), include_blank: 'Choose plan'
      f.input :valid_through, hint: 'Optional'
      f.input :coupon, hint: 'Valid Stripe Coupon Code. Optional.'
      f.li "<h2><strong>Benefits summary of the offered membership tier</strong></h2>".html_safe
      f.input :benefit_lead_in, as: :text, input_html: { rows: 6 }, hint: 'Required'
      f.li "<h2><strong>Optional. Further benefits of this membership tier</strong></h2>".html_safe
      f.input :box_2, input_html: { rows: 6 }, hint: 'Optional. Markdown supported.'
      f.li "<h2><strong>Optional. Further benefits of this membership tier</strong></h2>".html_safe
      f.input :box_3, input_html: { rows: 6 }, hint: 'Optional. Markdown supported.'
      f.li "<h2><strong>Email submit button text</strong></h2>".html_safe
      f.input :cta_button_text, hint: 'Required'
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
      row :box_1 do |offer|
        markdown offer.box_1
      end
      row 'YouTube video code' do |offer|
        offer.video_url
      end
      row :offer_lead_in
      row :plan
      if offer.plan.present?
        row :plan_detail do |offer|
          "Regular price #{offer.plan.display_price} with #{offer.plan.trial_period_days} day trial"
        end
      end
      row :offer_valid_through do |offer|
        offer.valid_through
      end
      row 'Membership benefits' do |offer|
        markdown offer.benefit_lead_in
      end
      row :box_2 do |offer|
        markdown offer.box_2
      end
      row :box_3 do |offer|
        markdown offer.box_3
      end
      row :cta_button_text
      # row :offer_lead_in
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
      # if offer.plan.present?
      #   row :benefit_lead_in do |offer|
      #     "With #{offer.plan.display_name} you can:"
      #   end
      # end
      # row :benefit_lead_in
    end
  end

end