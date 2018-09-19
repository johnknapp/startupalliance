class AddOkrFinishToOkrs < ActiveRecord::Migration[5.0]
  def change
    add_column :okrs, :okr_finish, :date
  end
end
