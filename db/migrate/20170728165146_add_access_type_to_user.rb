class AddAccessTypeToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :access_type, :string, default: 'guest'
  end
end
