ActiveAdmin.register Event do

  permit_params :title, :description, :start_time, :event_type, :alliance_id, :organizer_id, :state

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
