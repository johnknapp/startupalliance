ActiveAdmin.register Page do
  permit_params :title, :content, :author_id, :category_list => []

  scope('Not deleted')  { |scope| scope.all }
  scope('Soft deleted') { |scope| scope.only_deleted }

  controller do
    def find_resource
      scoped_collection.where(pid: params[:id]).first!
    end
  end

  index do
    selectable_column
    column :title do |page|
      link_to page.title, page_path(page), target: '_blank'
    end
    column 'Audit count' do |page|
      page.audits.count
    end
    column 'Content length' do |page|
      page.content.length
    end
    column :author
    column :categories do |page|
      page.category_list
    end
    column :updated_at
    actions
  end

  filter :author_id, label: "Author ID"

  show do
    attributes_table do
      row :audit_count do |page|
        page.audits.count
      end
      row :tags do |page|
        page.category_list
      end
      row :author
      row :title do |page|
        link_to page.title, page_path(page), target: '_blank'
      end
      row :content do |page|
        markdown page.content
      end
    end
  end

  form do |f|
    f.inputs 'Edit Page' do
      f.input :author_id, label: 'Author ID'
      f.input :title
      f.input :content
      f.input :category_list, as: :check_boxes, collection: Category.all.pluck(:name,:name)
    end
    f.actions
  end

end