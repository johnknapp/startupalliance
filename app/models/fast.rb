class Fast < ApplicationRecord
  include Pid

  belongs_to  :company
  belongs_to  :user

  has_many    :fastrs
  has_many    :strategies, through: :fastrs

  has_many    :factor_strats, class_name: :Fastr, foreign_key: :strategy_id
  has_many    :factors, through: :factor_strats, source: :fast

  enum type_code: {
      sufa: 0,
      rifa: 2,
      mast: 3,
      mist: 4
  }

end
