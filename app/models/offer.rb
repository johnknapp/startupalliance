class Offer < ApplicationRecord
  include Pid
  belongs_to  :plan
  has_many    :prospects
end
