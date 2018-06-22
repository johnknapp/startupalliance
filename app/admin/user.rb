ActiveAdmin.register User do

  menu parent: 'Subscriptions'

  permit_params :id, :pid, :first_name, :last_name, :username, :work_role, :mission, :bio, :email, :password, :password_confirmation,
                :current_password, :skill_index, :trait_index, :company_owner, :twitter_profile, :role,
                :linkedin_profile, :website, :country_code, :time_zone, :plan_id, :acqsrc, :public_skills, :public_traits

  scope('All')        { |scope| scope.all }
  scope('Trialing')   { |scope| scope.where(subscription_state: 'trialing') }
  scope('Active')     { |scope| scope.where(subscription_state: 'active') }
  scope('Past due')   { |scope| scope.where(subscription_state: 'past_due') }
  scope('Canceled')   { |scope| scope.where(subscription_state: 'canceled') }
  scope('Unpaid')     { |scope| scope.where(subscription_state: 'unpaid') }
  scope('Error')      { |scope| scope.where(subscription_state: 'error') }

  controller do

    def find_resource
      scoped_collection.where(pid: params[:id]).first!
    end

    def create
      if Rails.env.production?
        GibbonService.add_update(resource, ENV['MAILCHIMP_SITE_MEMBERS_LIST'])
      end
      super
    end

    def update
      if params[:user][:password].blank?
        %w[password password_confirmation].each { |p| params[:user].delete(p) }
      end
      if Rails.env.production?
        GibbonService.add_update(resource, ENV['MAILCHIMP_SITE_MEMBERS_LIST'])
      end
      super
    end

    def destroy
      departure_cleanup
      if Rails.env.production?
        GibbonService.unsubscribe(resource, ENV['MAILCHIMP_SITE_MEMBERS_LIST'])
      end
      super
    end

    private

      # Specifically not destroying any companies, okrs, FASTs or alliances they created
      def departure_cleanup
        okrs = Okr.where(owner_id: resource.id).all
        if okrs.present?
          okrs.each do |okr|
            okr.update(owner_id: okr.company.creator.id)
          end
        end

        fasts = Fast.where(user_id: resource.id).all
        if fasts.present?
          fasts.each do |fast|
            fast.update(user_id: fast.company.creator.id)
          end
        end

        jk = User.where(email: 'john@startupalliance.com') if Rails.env.production?
        jk = User.find 1 if Rails.env.development?
        Page.where(author_id: resource.id).update_all(author_id: jk.id)

        Stripe::Customer.retrieve(id: resource.stripe_customer_id).delete if resource.stripe_customer_id
      end

  end

  index do
    selectable_column
    column :id
    column :created_at
    column :pid
    column :name do |user|
      "#{user.name}"
    end
    column :username do |user|
      link_to user.username, vanity_path(user.username)
    end
    column :work_role
    column :role
    column :plan
    column :subscription_state
    column :skill_index
    column :trait_index
    # column :company_owner
    column :email do |user|
      mail_to user.email, user.email
    end
    actions
  end

  filter :created_at
  filter :first_name
  filter :last_name
  filter :email
  filter :state,                as: :select, collection: USER_STATES
  filter :role,                 as: :select, collection: USER_ROLES
  filter :work_role,            as: :select, collection: WORK_ROLE
  filter :plan
  filter :stripe_customer_id
  filter :stripe_coupon_code
  filter :subscribed_at
  filter :subscription_state,   as: :select, collection: SUBSCRIPTION_STATES

  form do |f|
    f.inputs 'Edit User' do
      f.input :first_name
      f.input :last_name
      f.input :username
      f.input :mission
      f.input :email
      f.input :work_role,     as: :select, collection: WORK_ROLE
      # f.input :company_owner
      f.input :public_skills
      f.input :public_traits
      f.input :password
      f.input :password_confirmation
      f.input :role,                collection: USER_ROLES
      f.input :state,               collection: USER_STATES
      f.input :plan
      # f.input :subscribed_at
      # f.input :subscription_state,  collection: SUBSCRIPTION_STATES
    end
    f.actions
  end

end