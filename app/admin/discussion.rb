ActiveAdmin.register Discussion do

  menu parent: 'Forums'

  permit_params :name, :description, :slug, :author_id, :nucleus

  controller do
    def find_resource
      scoped_collection.where(pid: params[:id]).first!
    end
  end

  index do
    selectable_column
    column :nucleus
    column :slug
    column :name
    column :topic_count do |disco|
      disco.topics.count
    end
    column :discussable_type
    column :author
    actions
  end

  # filter :id
  # filter :pid
  filter :nucleus
  filter :slug
  filter :name
  filter :discussable_type
  filter :author_id, label: "Author ID"

  show do
    attributes_table do
      row :slug
      row :name
      row :description
      row :discussable_type
      row :discussable
      row :nucleus
      row :author
      row :topic_count do |disco|
        disco.topics.count
      end
      panel "Topics" do
        table_for discussion.topics do
          column :name do |topic|
            link_to topic.name, admin_topic_path(topic)
          end
          column :author
          column :post_count do |topic|
            topic.posts.count
          end
        end
      end
    end
  end

  form do |f|
    f.inputs 'Edit Discussion' do
      f.input :nucleus, label: 'Appears in Nucleus'
      f.input :name
      f.input :description
      f.input :author_id, label: 'Author ID'
    end
    actions
  end

end