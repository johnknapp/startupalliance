class PrepDiscussionsForNucleus < ActiveRecord::Migration[5.0]
  def up
    add_column    :discussions, :nucleus,          :boolean,              default: false
    change_column :discussions, :discussable_id,   :integer,  null: true
    change_column :discussions, :discussable_type, :string,   null: true
  end
  def down
    remove_column :discussions, :nucleus,          :boolean
    change_column :discussions, :discussable_id,   :integer,  null: false
    change_column :discussions, :discussable_type, :string,   null: false
  end
end
