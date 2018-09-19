class AddTrialDaysToPlans < ActiveRecord::Migration[5.0]
  def change
    add_column :plans, :trial_period_days, :integer, default: 0
  end
end
