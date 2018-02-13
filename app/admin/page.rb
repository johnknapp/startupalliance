ActiveAdmin.register Page do
  permit_params :title, :content, :category_list => []

  scope('Not deleted')  { |scope| scope.all }
  scope('Soft deleted') { |scope| scope.only_deleted }

  controller do
    def find_resource
      scoped_collection.where(pid: params[:id]).first!
    end
  end

  index do
    selectable_column
    column :title
    column 'Audit count' do |page|
      page.audits.count
    end
    column 'Content length' do |page|
      page.content.length
    end
    column :categories do |page|
      page.category_list
    end
    actions
  end

  show do
    attributes_table do
      row :audit_count do |page|
        page.audits.count
      end
      row :tags do |page|
        page.category_list
      end
      row :title
      row :content do |page|
        markdown page.content
      end
    end
  end

  form do |f|
    f.inputs 'Edit Page' do
      f.input :title
      f.input :content
      f.input :category_list, as: :check_boxes, collection: Category.all.pluck(:name,:name)
    end
    f.actions
  end

end