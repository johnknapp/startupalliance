class YagniOne < ActiveRecord::Migration[5.0]
  def change
    remove_column :alliances, :state,     :string,  default: 'initialized'
    remove_column :companies, :state,     :string,  default: 'initialized'
    remove_column :companies, :latitude,  :string
    remove_column :companies, :longitude, :string
    remove_column :messages,  :is_read,   :boolean, default: false
    remove_column :okrs,      :state,     :string,  default: 'initialized'
    remove_column :users,     :latitude,  :float
    remove_column :users,     :longitude, :float
  end
end
