class AddParentIdAndReadToComments < ActiveRecord::Migration[5.0]
  def change
    add_column :comments, :ancestry, :string
    add_column :comments, :read, :boolean, default: false
    add_index  :comments, :ancestry
  end
end
