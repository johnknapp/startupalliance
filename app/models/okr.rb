class Okr < ApplicationRecord
  include Pid
  belongs_to :company
  belongs_to :owner, foreign_key: :owner_id,    class_name: 'User'

  has_many :fasts

  before_validation do
    set_okr_finish
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

  scope :upcoming,  -> { where('okr_start >= ?',Time.zone.now).or(Okr.where(okr_start: nil)) }
  scope :active,    -> { where('okr_start <= ?',Time.zone.now).where('okr_finish >= ?',Time.zone.now) }
  scope :concluded, -> { where('okr_finish <= ?',Time.zone.now) }

  def date_unset?
    self.okr_start.nil?
  end

  def set_score
    arr = []
    arr << self.kr1_score if self.kr1_score != 0
    arr << self.kr2_score if self.kr2_score != 0
    arr << self.kr3_score if self.kr3_score != 0
    self.update(score: ((arr.sum)/arr.count).round(2)) if !arr.empty?
  end

  def set_okr_finish
    self.update_attribute(:okr_finish, okr_end)
  end

  private

    def okr_end
      d = self.okr_duration
      u = self.okr_units.downcase
      self.okr_start.advance(u.to_sym => d) if self.okr_start
    end

end
