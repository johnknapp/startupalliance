class Offer < ApplicationRecord
  include Pid
  belongs_to :plan
end
