class AddCategoriesToPages < ActiveRecord::Migration[5.0]
  def change
    add_column :pages, :category_array, :string, array: true, default: []
  end
end
