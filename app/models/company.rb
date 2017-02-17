class Company < ApplicationRecord
  include Pid
  has_many  :company_users
  has_many  :team, through: :company_users, source: :user
  has_many  :okrs
  has_many  :company_sakpis
  has_many  :sakpis, through: :company_sakpis

  validates :url, url: { allow_nil: true, allow_blank: true, no_local: true }

  enum phases: {
      Ideation:         0,
      Validation:       1,
      Foundation:       2,
      Fortification:    3,
      Expansion:        4,
      Diversification:  5
  }

end
