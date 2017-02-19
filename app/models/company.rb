class Company < ApplicationRecord
  include Pid
  include Webmeet
  has_many  :company_users
  has_many  :team, through: :company_users, source: :user
  has_many  :okrs
  has_many  :company_sakpis
  has_many  :sakpis, through: :company_sakpis

  validates :url, url: { allow_nil: true, allow_blank: true, no_local: true }
  validates :webmeet_url, url: { allow_nil: true, allow_blank: true, no_local: true }

  enum phases: {
      Ideation:         0,
      Validation:       1,
      Foundation:       2,
      Fortification:    3,
      Expansion:        4,
      Diversification:  5
  }

  def team_member(user)
    CompanyUser.where(user_id: user.id, company_id: self.id).first
  end

  def sakpi_index
    arr = []
    sakpis = self.company_sakpis
    sakpis.each do |kpi|
      arr << kpi.level
    end
    arr.sum
  end

end
