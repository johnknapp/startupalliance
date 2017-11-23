class Fast < ApplicationRecord
  include Pid

  belongs_to  :company
  belongs_to  :user

  has_many    :fact_strats
  has_many    :strategies, through: :fact_strats

  has_many    :factors, class_name: :FastStrat, foreign_key: :factor_id
  has_many    :factors, through: :fact_strats, source: :fast

end
