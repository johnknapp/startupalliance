class Company < ApplicationRecord
  include Pid
  has_many :company_users
  has_many :founders, through: :company_users, source: :user
  has_many :okrs

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
