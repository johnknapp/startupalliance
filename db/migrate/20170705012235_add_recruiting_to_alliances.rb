class AddRecruitingToAlliances < ActiveRecord::Migration[5.0]
  def change
    add_column :alliances, :recruiting, :boolean, default: true
  end
end
