class Okr < ApplicationRecord
  include Pid
  belongs_to :company
end
