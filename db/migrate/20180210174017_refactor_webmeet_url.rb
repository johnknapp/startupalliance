class RefactorWebmeetUrl < ActiveRecord::Migration[5.0]
  def change
    rename_column :companies, :webmeet_url, :webmeet_code
    rename_column :alliances, :webmeet_url, :webmeet_code
  end
end
