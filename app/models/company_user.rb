class CompanyUser < ApplicationRecord
  belongs_to :company
  belongs_to :user
  enum equity: {
      no_equity:  0,
      over_5:     1,
      over_10:    2,
      over_25:    3,
      over_33:    4,
      over_50:    5,
      over_75:    6
  }
end
