class Event < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, 
         :recoverable, :rememberable, :trackable, :validatable
  include Pid
  include Search

  belongs_to :organizer, class_name: :User, counter_cache: true
  belongs_to :alliance

  validates :title, length: { maximum: 140 }, presence: true
  validates :description, length: { maximum: 1024 }, presence: true

  enum state: {
      discussion:       0,
      presentation:     1,
      hangout:          2
  }

end
