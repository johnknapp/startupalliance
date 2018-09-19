class AddPublicSkillTraitToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :public_skills, :boolean, default: false
    add_column :users, :public_traits, :boolean, default: false
  end
end
