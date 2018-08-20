ActiveAdmin.register Alliance do

  permit_params :id, :pid, :name, :mission, :webmeet_code, :recruiting, :creator_id, :is_unlisted, :invite_only, :state

  controller do
    def find_resource
      scoped_collection.where(pid: params[:id]).first!
    end
  end

  index do
    selectable_column
    column :pid
    column :creator
    column :name
    column :headcount do |alliance|
      alliance.members.count
    end
    column :recruiting
    column :invite_only
    column :is_unlisted
    column :state
    actions
  end

  filter :pid
  filter :name
  filter :creator
  filter :recruiting
  filter :invite_only
  filter :is_unlisted
  filter :state

end