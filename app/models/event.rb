class Event < ApplicationRecord
  include Pid
  include Search

  belongs_to :organizer, class_name: :User, counter_cache: true
  belongs_to :alliance

  validates :title, length: { maximum: 140 }, presence: true
  validates :description, length: { maximum: 1024 }, presence: true

  after_validation(on: :create) do
    update_attribute(:access_url, WEBRTC_EVENT_URL + self.pid)
  end

  enum event_type: {
      Discussion:       0,
      Presentation:     1,
      Hangout:          2
  }

end
