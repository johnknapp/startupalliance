class Classified < ApplicationRecord
  include Pid
  include Search

  belongs_to :creator, class_name: :User

  validates :title, length: { maximum: 140 }, presence: true
  validates :body,  length: { maximum: 1024 }, presence: true
end
