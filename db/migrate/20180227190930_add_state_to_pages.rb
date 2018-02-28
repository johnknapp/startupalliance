class AddStateToPages < ActiveRecord::Migration[5.0]
  def change
    add_column :pages, :state, :string, default: 'Draft'
  end
end
