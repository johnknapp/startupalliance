ActiveAdmin.register User do

  menu parent: 'Subscriptions'

  permit_params :id, :pid, :first_name, :last_name, :username, :mission, :bio, :email, :password, :password_confirmation,
                :current_password, :skill_index, :trait_index, :company_owner, :twitter_profile, :role,
                :linkedin_profile, :website, :country_code, :time_zone, :plan_id, :acqsrc, :public_skills, :public_traits

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

      # Specifically not destroying any companies, okrs or alliances they created
      def departure_cleanup
        okrs = Okr.where(owner_id: @user.id).all
        if okrs.present?
          okrs.each do |okr|
            okr.update(owner_id: okr.company.creator.id)
          end
        end
        AllianceUser.where(user_id: @user.id).destroy_all
        CompanyUser.where(user_id: @user.id).destroy_all
        UserSkill.where(user_id: @user.id).destroy_all
        UserTrait.where(user_id: @user.id).destroy_all
        Conversation.includes?(@user).destroy_all
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
    column :state
    column :role
    column :plan
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
  filter :state,        as: :select, collection: USER_STATES
  filter :role,         as: :select, collection: USER_ROLES
  filter :plan

  form do |f|
    f.inputs 'Edit User' do
      f.input :first_name
      f.input :last_name
      f.input :username
      f.input :mission
      f.input :email
      f.input :company_owner
      f.input :public_skills
      f.input :public_traits
      f.input :password
      f.input :password_confirmation
      f.input :role,          collection: USER_ROLES
      f.input :state,         collection: USER_STATES
      f.input :plan
      f.input :acqsrc
    end
    f.actions
  end

end