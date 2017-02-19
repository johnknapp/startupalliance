class Okr < ApplicationRecord
  include Pid
  belongs_to :company

  enum okr_units: {
      months:    0,
      weeks:     1,
      days:      2
  }

  def past?
  end

  def present?
  end

  def future?
  end

end
