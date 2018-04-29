class Alliance < ApplicationRecord
  include Pid
  include Webmeet
  has_many    :discussions, as: :discussable, dependent: :destroy
  has_many    :alliance_users, dependent: :destroy
  has_many    :members, through: :alliance_users, source: :user
  belongs_to  :creator, class_name: :User

  enum state: {
      Active:           0,
      Frozen:           1,
      Closed:           2
  }

  def member_companies
    arr = []
    self.members.each do |member|
      member.companies.where(is_unlisted: false).each do |company|
        arr << company
      end
    end
    arr.uniq
  end

end
