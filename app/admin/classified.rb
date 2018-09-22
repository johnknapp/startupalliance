ActiveAdmin.register Classified do

  menu parent: 'Nucleus'

  permit_params :title, :body

  controller do
    def find_resource
      scoped_collection.where(pid: params[:id]).first!
    end
  end

  index do
    selectable_column
    column :id
    column :title
    column :creator
    column :created_at do |classified|
      classified.created_at.strftime('%m/%e/%y %H:%M %Z')
    end
    column :pid
    actions
  end

  filter :title
  filter :body
  filter :creator_id, label: 'Creator ID'

end
