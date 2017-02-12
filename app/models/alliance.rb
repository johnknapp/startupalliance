class Alliance < ApplicationRecord
  include Pid
  has_many :alliance_users
  has_many :members, through: :alliance_users
end
