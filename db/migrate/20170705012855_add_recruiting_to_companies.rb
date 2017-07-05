class AddRecruitingToCompanies < ActiveRecord::Migration[5.0]
  def change
    add_column :companies, :recruiting, :boolean, default: true
  end
end
