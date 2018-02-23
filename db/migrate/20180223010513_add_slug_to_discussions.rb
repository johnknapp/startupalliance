class AddSlugToDiscussions < ActiveRecord::Migration[5.0]
  def change
    add_column :discussions, :slug, :string
  end
end
