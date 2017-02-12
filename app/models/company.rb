class Company < ApplicationRecord
  include Pid
  has_many :company_users
  has_many :founders, through: :company_users, source: :user
  has_many :okrs

  validates :url, url: { allow_nil: true, allow_blank: true, no_local: true }

end
