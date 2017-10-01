class Comment < ApplicationRecord
  include Pid
  has_many    :replies, dependent: :destroy
  belongs_to  :discussion
  belongs_to  :author, class_name: :User

  validates :body, length: { maximum: 2048 }

end
