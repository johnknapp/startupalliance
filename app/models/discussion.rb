class Discussion < ApplicationRecord
  include Pid
  belongs_to  :discussable, polymorphic: true
  belongs_to  :author, class_name: :User
  has_many    :posts, dependent: :destroy

  validates :title,       length: { maximum: 255 }
  validates :description, length: { maximum: 1024 }

end
