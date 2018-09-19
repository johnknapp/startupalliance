class AddOkrIdAndSakpiIdToFasts < ActiveRecord::Migration[5.0]
  def change
    add_column :fasts, :okr_id, :integer
    add_column :fasts, :sakpi_id, :integer
  end
end
