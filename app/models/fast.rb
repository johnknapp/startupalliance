class Fast < ApplicationRecord
  include Pid

  belongs_to  :company
  belongs_to  :user

  has_many    :fact_strats
  has_many    :strategies, through: :fact_strats

  has_many    :fact_strats, class_name: :FactStrat, foreign_key: :strategy_id
  has_many    :factors, through: :fact_strats, source: :fast

end
