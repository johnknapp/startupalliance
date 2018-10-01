class Event < ApplicationRecord
  include Pid
  include Search

  belongs_to :organizer, class_name: :User, counter_cache: true
  belongs_to :alliance

  validates :title, length: { maximum: 140 }, presence: true
  validates :description, length: { maximum: 1024 }

  enum event_type: {
      AMA:      0,
      Hangout:  1,
      Lecture:  2
  }

  scope :upcoming, -> { where('start_time > ?', Time.zone.now).order(:start_time) }

end
