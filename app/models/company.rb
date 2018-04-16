class Company < ApplicationRecord
  include Pid
  include CountryName
  include Webmeet
  has_many    :discussions, as: :discussable, dependent: :destroy
  has_many    :company_users
  has_many    :team, through: :company_users, source: :user
  belongs_to  :creator, class_name: :User
  has_many    :okrs
  has_many    :fasts
  has_many    :company_sakpis
  has_many    :sakpis, through: :company_sakpis

  accepts_nested_attributes_for :company_users

  validates :url, url: { allow_nil: true, allow_blank: true, no_local: true }

  enum state: {
      Active:           0,
      Frozen:           1,
      Closed:           2
  }

  enum phases: {
      Ideation:         0,
      Validation:       1,
      Operational:      2,
      Growth:           3,
      Diversification:  4
  }

  # used to test company_user.role (enum)
  def team_member(user)
    CompanyUser.where(user_id: user.id, company_id: self.id).first
  end

end
