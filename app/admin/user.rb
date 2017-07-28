ActiveAdmin.register User do

  permit_params :id, :pid, :first_name, :last_name, :username, :mission, :bio, :email, :password, :password_confirmation,
                :current_password, :skill_index, :trait_index, :company_owner, :twitter_profile, :role, :state,
                :linkedin_profile, :website, :location, :latitude, :longitude, :time_zone, :access_type, :acqsrc

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
      resource.conversations.destroy_all
      if Rails.env.production?
        GibbonService.unsubscribe(resource, ENV['MAILCHIMP_SITE_MEMBERS_LIST'])
      end
      super
    end

  end

  index do
    selectable_column
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
    column :access_type
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
  filter :access_type,  as: :select, collection: USER_ACCESS_TYPES
  filter :company_owner

  form do |f|
    f.inputs 'Edit User' do
      f.input :first_name
      f.input :last_name
      f.input :username
      f.input :mission
      f.input :email
      f.input :company_owner
      f.input :password
      f.input :password_confirmation
      f.input :role,          collection: USER_ROLES
      f.input :state,         collection: USER_STATES
      f.input :access_type,   collection: USER_ACCESS_TYPES
      f.input :acqsrc
    end
    f.actions
  end

end