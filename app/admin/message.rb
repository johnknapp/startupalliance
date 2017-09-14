ActiveAdmin.register Message do

  menu parent: 'Interactions'

  actions :all, except: [:new, :edit]

  controller do
    def find_resource
      scoped_collection.where(pid: params[:id]).first!
    end
  end

  index do
    selectable_column
    column :id
    column :author
    column :body
    column :read
    column :started do |message|
      link_to message.conversation.created_at.strftime('%m/%e/%y %H:%M %Z'), admin_conversation_path(message.conversation)
    end
    actions
  end

  filter :author
  filter :body
  filter :read

end