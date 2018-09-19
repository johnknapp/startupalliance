class ChangeUsersPlanDefault < ActiveRecord::Migration[5.0]
  def change
    change_column_default :users, :plan, from: 'associate', to: 'free'
  end
end
