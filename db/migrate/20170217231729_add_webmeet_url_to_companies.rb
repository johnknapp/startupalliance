class AddWebmeetUrlToCompanies < ActiveRecord::Migration[5.0]
  def change
    add_column :companies, :webmeet_url, :string
  end
end
