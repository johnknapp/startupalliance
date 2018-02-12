class Sakpi < ApplicationRecord
  has_many  :company_sakpis
  has_many  :companies, through: :company_sakpis

  def display_name
    self.name.gsub('&nbsp;',' ')
  end

end
