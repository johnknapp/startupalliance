ActiveAdmin.register Topic do

  menu parent: 'Forums'

  permit_params :name, :discussion_id, :author_id

  controller do
    def find_resource
      scoped_collection.where(pid: params[:id]).first!
    end
  end

  index do
    selectable_column
    column :name do |topic|
      link_to topic.name, discussion_topic_path(topic.discussion,topic), target: '_blank'
    end
    column :discussion, sortable: 'topic.discussion'
    column :post_count do |topic|
      topic.posts.count
    end
    column :author
    column :updated_at
    actions
  end

  filter :name
  filter :discussion
  filter :author_id, label: "Author ID"

  show do
    attributes_table do
      row :name do |topic|
        link_to topic.name, discussion_topic_path(topic.discussion,topic), target: '_blank'
      end
      row :discussion
      row :author
      row :post_count do |topic|
        topic.posts.count
      end
      panel "Posts" do
        table_for topic.posts do
          column :body do |post|
            link_to post.body, admin_post_path(post)
          end
          column :author
        end
      end
    end
  end

  form do |f|
    f.inputs 'Edit Topic' do
      f.input :discussion
      f.input :name
      f.input :author_id, label: 'Author ID'
    end
    actions
  end

end