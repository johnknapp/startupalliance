ActiveAdmin.register Category do

  config.sort_order = 'name_asc'

  permit_params :name

  menu parent: 'JK only'

  index do
    selectable_column
    column :name
    column 'Page count' do |category|
      Page.tagged_with(category.name).count
    end
    actions
  end

  form do |f|
    f.inputs do
      f.input :name, hint: 'Category names containing a comma are strictly forbidden due to parse errors!'
    end
    f.actions
  end

  end