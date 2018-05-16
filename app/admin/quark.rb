ActiveAdmin.register Quark do

  permit_params :text, :author_id, :state

  controller do
    def find_resource
      scoped_collection.where(pid: params[:id]).first!
    end
  end

  index do
    selectable_column
    column :text
    column :author
    column :state
    actions
  end

  filter :text
  filter :author
  filter :state, as: :select, collection: QUARK_STATES

  form do |f|
    f.inputs 'Edit Quark' do
      f.input :text
      f.input :author
      f.input :state, collection: QUARK_STATES
    end
    actions
  end

end
