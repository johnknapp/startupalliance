ActiveAdmin.register Category do

  config.sort_order = 'name_asc'

  permit_params :name

  menu parent: 'Attributes'

  index do
    selectable_column
    column :name
    column 'Page count' do |category|
      Page.tagged_with(category.name).count
    end
    actions
  end

  end