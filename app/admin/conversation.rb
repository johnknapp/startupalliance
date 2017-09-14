ActiveAdmin.register Conversation do

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
    column :started do |conversation|
      conversation.created_at.strftime('%m/%e/%y %H:%M %Z')
    end
    column :sender
    column :recipient
    column :messages do |conversation|
      conversation.messages.count
    end
    actions
  end

  filter :sender
  filter :recipient
  filter :created_at

  show do
    attributes_table do
      row :sender
      row :recipient
      row :id
      row :message_count do |conversation|
        conversation.messages.count
      end
    end
    panel "Messages (#{conversation.messages.count}" do
      table_for conversation.messages do
        column :author
        column :read
        column :message do |message|
          link_to message.body, admin_message_path(message)
        end
        # column :body
      end
    end
  end
end