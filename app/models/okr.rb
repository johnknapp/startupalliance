class Okr < ApplicationRecord
  include Pid
  belongs_to :company
  belongs_to :owner, foreign_key: :owner_id,    class_name: 'User'

  has_many :fasts

  before_validation do
    self.update_attribute(:okr_finish, self.okr_end)
  end

  enum okr_units: {
      Months:    0,
      Weeks:     1,
      Days:      2
  }

  enum status:  {
      Green:    0,
      Yellow:   1,
      Red:      2
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

  scope :upcoming,  -> { where('okr_start >= ?',Time.now).where.not(okr_start: nil) }
  scope :active,    -> { where('okr_start <= ?',Time.now).where('okr_finish >= ?',Time.now) }
  scope :concluded, -> { where('okr_finish <= ?',Time.now) }

  def date_unset?
    self.okr_start.nil?
  end

  def okr_end
    d = self.okr_duration
    u = self.okr_units.downcase
    self.okr_start.advance(u.to_sym => d) if self.okr_start
  end

  def set_score
    arr = []
    arr << self.kr1_score if self.kr1_score != 0
    arr << self.kr2_score if self.kr2_score != 0
    arr << self.kr3_score if self.kr3_score != 0
    self.update(score: ((arr.sum)/arr.count).round(2)) if !arr.empty?
  end
end
