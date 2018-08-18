ActiveAdmin.register Alliance do

  permit_params :id, :pid, :name, :mission, :webmeet_code, :recruiting, :creator_id, :is_unlisted, :state

  controller do
    def find_resource
      scoped_collection.where(pid: params[:id]).first!
    end
  end

  index do
    selectable_column
    column :pid
    column :name
    column :mission
    column :is_unlisted
    column :state
    column :creator
    actions
  end

end