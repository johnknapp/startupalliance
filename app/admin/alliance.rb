ActiveAdmin.register Alliance do

  permit_params :id, :pid, :name, :mission, :webmeet_url, :state, :recruiting, :creator_id

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
    column :webmeet do |alliance|
      link_to alliance.webmeet_url, alliance.webmeet_url
    end
    column :state
    actions
  end

end