class AddEventsCountToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :events_count, :integer,           default: 0,             null: false
  end
end
