class ModifyPagesIndex < ActiveRecord::Migration[5.0]
  def up
    remove_index  :pages, :title
    add_index     :pages, :title
  end
  def down
    remove_index  :pages, :title
    add_index     :pages, :title, unique: true
  end
end
