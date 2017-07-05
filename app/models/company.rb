class Company < ApplicationRecord
  include Pid
  include Webmeet
  has_many    :company_users
  has_many    :team, through: :company_users, source: :user
  belongs_to  :creator, class_name: :User
  has_many    :okrs
  has_many    :company_sakpis
  has_many    :sakpis, through: :company_sakpis

  accepts_nested_attributes_for :company_users

  validates :url, url: { allow_nil: true, allow_blank: true, no_local: true }
  validates :webmeet_url, url: { allow_nil: true, allow_blank: true, no_local: true }

  enum phases: {
      '1: Ideation':         0,
      '2: Validation':       1,
      '3: Foundation':       2,
      '4: Fortification':    3,
      '5: Expansion':        4,
      '6: Diversification':  5
  }

  def team_member(user)
    CompanyUser.where(user_id: user.id, company_id: self.id).first
  end

end
