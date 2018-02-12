ActiveAdmin.register Page do
  permit_params :title, :content

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
    column 'Category count' do |page|
      page.category_list.count
    end
    actions
  end

  show do
    attributes_table do
      row :audit_count do |page|
        page.audits.count
      end
      row :title
      row :content do |page|
        markdown page.content
      end
    end
  end

end