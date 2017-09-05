class RefactorOkrs < ActiveRecord::Migration[5.0]
  def change
    rename_column :okrs, :mid_score,    :status
    change_column_default :okrs, :status, from: nil, to: 0
    remove_column :okrs, :final_score,  :integer
    add_column    :okrs, :score,        :float,   default: 0
    add_column    :okrs, :kr1_score,    :float,   default: 0
    add_column    :okrs, :kr2_score,    :float,   default: 0
    add_column    :okrs, :kr3_score,    :float,   default: 0
    add_column    :okrs, :owner_id,     :integer
    add_column    :okrs, :sakpi_id,     :integer
  end
end
