class Reply < ApplicationRecord
  include Pid
  belongs_to  :comment
  belongs_to  :author, class_name: :User

  validates :body, length: { maximum: 2048 }

end
