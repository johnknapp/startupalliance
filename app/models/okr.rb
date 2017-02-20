class Okr < ApplicationRecord
  include Pid
  belongs_to :company

  enum okr_units: {
      months:    0,
      weeks:     1,
      days:      2
  }

  def concluded?
    self.okr_end <= Date.today
  end

  def active?
    self.okr_start <= Date.today and self.okr_end >= Date.today
  end

  def upcoming?
    self.okr_start >= Date.today
  end

  def okr_end
    d = self.okr_duration
    u = self.okr_units
    self.okr_start.advance(u.to_sym => d)
  end

end
