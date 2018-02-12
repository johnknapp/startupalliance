ActiveAdmin.register Category do

  permit_params :name

  menu parent: 'Attributes'

end