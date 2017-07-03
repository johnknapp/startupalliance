class Alliance < ApplicationRecord
  include Pid
  include Webmeet
  has_many :alliance_users
  has_many :members, through: :alliance_users, source: :user
  belongs_to  :creator, class_name: :User

  validates :webmeet_url, url: { allow_nil: true, allow_blank: true, no_local: true }

end
