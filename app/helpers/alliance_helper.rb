module AllianceHelper

  # return alliance member scoped company_user records
  def alliance_company_team(alliance,company)
    CompanyUser.where(company_id: company.id).where('user_id in (?)', alliance.members.pluck(:user_id))
  end

end