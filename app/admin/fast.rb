ActiveAdmin.register Fast do
  permit_params :body, :type_code, :company_id, :user_id

  controller do
    def find_resource
      scoped_collection.where(pid: params[:id]).first!
    end
  end

  index do
    selectable_column
    column :type_code
    column :body
    column :company
    # See https://stackoverflow.com/questions/11148316/activeadmin-how-to-sort-column-with-associations
    # column :company, nil, sortable: "company.name"
    column :user
    actions
  end

  filter :type_code
  filter :company
  filter :user
  

end