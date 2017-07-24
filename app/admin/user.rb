ActiveAdmin.register User do

  permit_params :id, :pid, :first_name, :last_name, :username, :mission, :bio, :email, :password, :password_confirmation,
                :current_password, :skill_index, :trait_index, :company_owner, :twitter_profile,
                :linkedin_profile, :website, :location, :latitude, :longitude, :time_zone, :discussion_admin,
                :discussion_moderator

  controller do
    def find_resource
      scoped_collection.where(pid: params[:id]).first!
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
    column :mission
    column :skill_index
    column :trait_index
    column :discussion_moderator
    column :discussion_admin
    column :company_owner
    column :email do |user|
      mail_to user.email, user.email
    end
    actions
  end

  filter :created_at
  filter :first_name
  filter :last_name
  filter :email
  filter :discussion_moderator
  filter :discussion_admin
  filter :company_owner
  filter :role
  filter :state

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
      f.input :discussion_moderator
      f.input :discussion_admin
      f.input :role
      f.input :state
    end
    f.actions
  end

end