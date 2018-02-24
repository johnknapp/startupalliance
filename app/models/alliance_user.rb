class AllianceUser < ApplicationRecord
  belongs_to :alliance
  belongs_to :user

  def self.team_mates(first_id,second_id)
    alliance_ids = AllianceUser.where(user_id: first_id).pluck(:alliance_id)
    AllianceUser.where('alliance_id in (?)',alliance_ids).pluck(:user_id).any?{ |user_id| user_id == second_id }
  end

end
