class AddAuthorIdToPages < ActiveRecord::Migration[5.0]
  def change
    add_column :pages, :author_id, :integer
  end
end
