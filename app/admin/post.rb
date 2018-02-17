ActiveAdmin.register Post do

  menu parent: 'Forums'

  permit_params :body, :topic_id, :author_id

  controller do
    def find_resource
      scoped_collection.where(pid: params[:id]).first!
    end
  end

  index do
    selectable_column
    column :body
    column :topic
    column :author
    actions
  end

  filter :body
  filter :topic
  filter :author_id, label: "Author ID"

  form do |f|
    f.inputs 'Edit Post' do
      f.input :topic
      f.input :body
      f.input :author_id, label: 'Author ID'
    end
    actions
  end

  show do
    attributes_table do
      row :body
      row :topic
      row :author
    end
  end


end