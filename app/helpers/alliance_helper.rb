module AllianceHelper

  def alliance_pvo_url
    WEBRTC_PRIVATE_URL + @alliance.webmeet_code
  end

  # return alliance member scoped company_user records
  def alliance_company_team(alliance,company)
    CompanyUser.where(company_id: company.id).where('user_id in (?)', alliance.members.pluck(:user_id))
  end

end