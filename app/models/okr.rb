class Okr < ApplicationRecord
  include Pid
  belongs_to :company

  enum okr_units: {
      Months:    0,
      Weeks:     1,
      Days:      2
  }

  def concluded?
    self.okr_end <= Date.today if self.okr_end
  end

  def active?
    self.okr_start <= Date.today and self.okr_end >= Date.today if self.okr_start
  end

  def upcoming?
    self.okr_start >= Date.today if self.okr_start
  end

  def date_unset?
    self.okr_start.nil?
  end

  def okr_end
    d = self.okr_duration
    u = self.okr_units
    self.okr_start.advance(u.to_sym => d) if self.okr_start
  end

end
