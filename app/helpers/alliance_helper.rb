module AllianceHelper

  # return alliance member scoped company_user records
  def alliance_company_team(alliance,company)
    alliance_user_ids = alliance.members.pluck(:user_id)
    CompanyUser.where(company_id: company.id).where('user_id in (?)', alliance_user_ids)
  end

end