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
    column :start_time do |event|
      event.start_time.strftime('%m/%e/%y %H:%M %Z')
    end
    actions
  end

  form do |f|
    f.inputs 'Edit Page' do
      f.input :state, collection: EVENT_STATES
      f.input :organizer_id, label: 'Organizer ID'
      f.input :title
      f.input :description
      f.input :event_type
      f.input :start_time
    end
    f.actions
  end

end
