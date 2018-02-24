class CompanyUser < ApplicationRecord
  belongs_to :company
  belongs_to :user

  def self.team_mates(first_id,second_id)
    company_ids = CompanyUser.where(user_id: first_id).pluck(:company_id)
    CompanyUser.where('company_id in (?)',company_ids).pluck(:user_id).any?{ |user_id| user_id == second_id }
  end

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
  # see company helper
  enum role:{
      Owner:      0,
      Employee:   1,
      Advisor:    2,
      Consultant: 3,
      Investor:   4
  }
end
