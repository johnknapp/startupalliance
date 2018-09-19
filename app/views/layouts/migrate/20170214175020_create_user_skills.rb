class CreateUserSkills < ActiveRecord::Migration[5.0]
  def change
    create_table :user_skills do |t|
      t.integer :user_id
      t.integer :skill_id
      t.integer :level

      t.timestamps
    end
  end
end
