class UpdateCompanyNameRequired < ActiveRecord::Migration[5.0]
  def change
    change_column_null :companies, :name, false, ''
  end
end
