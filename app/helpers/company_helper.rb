module CompanyHelper

  def team_role(company,user)
    company_user = CompanyUser.where(company_id: company.id).where(user_id: user.id).first
    if company_user
      company_user.role
    else
      'unknown'
    end
  end

  def team_roles
    roles = [
      ['Owner','Owner'],
      ['Employee','Employee'],
      ['Advisor','Advisor'],
      ['Investor','Investor']
    ]
  end

end