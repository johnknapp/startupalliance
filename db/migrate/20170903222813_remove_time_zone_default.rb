class RemoveTimeZoneDefault < ActiveRecord::Migration[5.0]
  def change
    change_column_default :companies, :time_zone, from: 'Pacific Time (US & Canada)', to: nil
    change_column_default :users, :time_zone, from: 'Pacific Time (US & Canada)', to: nil
  end
end
