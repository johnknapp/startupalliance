ActiveAdmin.register Event do

  menu parent: 'Nucleus'

  permit_params :title, :description, :start_time, :event_type, :alliance_id, :organizer_id, :state

  controller do
    def find_resource
      scoped_collection.where(pid: params[:id]).first!
    end
  end

  index do
    selectable_column
    column :id
    column :pid
    column :title
    column :event_type
    column :organizer
    column :start_time
    actions
  end

end
