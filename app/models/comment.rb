class Comment < ApplicationRecord
  include Pid
  belongs_to  :discussion
  belongs_to  :author, class_name: :User

  validates :body, length: { maximum: 2048 }

end
