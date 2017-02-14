class Sakpi < ApplicationRecord
  has_many :company_sakpis
  has_many :companies, through: :company_sakpis
end
