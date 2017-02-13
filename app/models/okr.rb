class Okr < ApplicationRecord
  include Pid
  belongs_to :company

  enum okr_units: {
      months:    0,
      weeks:     1,
      days:      2
  }

  def in_the_past?
  end

  def in_the_present?
  end

  def in_the_future?
  end

end
