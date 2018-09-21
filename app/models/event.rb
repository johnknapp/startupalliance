class Event < ApplicationRecord
  include Pid
  include Search

  belongs_to :organizer, class_name: :User, counter_cache: true

  validates :title, length: { maximum: 140 }, presence: true
  validates :description, length: { maximum: 1024 }, presence: true

  enum state: {
      discussion:       0,
      presentation:     1,
      hangout:          2
  }

end
