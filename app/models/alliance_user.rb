class AllianceUser < ApplicationRecord
  belongs_to :alliance
  belongs_to :user
end
