class AddThreddedColumnsToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :discussion_moderator, :boolean, default: false
    add_column :users, :discussion_admin, :boolean, default: false
  end
end
