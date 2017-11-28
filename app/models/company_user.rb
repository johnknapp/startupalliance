class CompanyUser < ApplicationRecord
  belongs_to :company
  belongs_to :user
  enum equity: {
      no_equity:  0,
      under_5:    1,
      over_5:     2,
      over_10:    3,
      over_25:    4,
      over_33:    5,
      over_50:    6,
      over_75:    7
  }
  enum role:{
      Owner:      0,
      Employee:   1,
      Advisor:    2,
      Consultant: 3,
      Investor:   4
  }
end
