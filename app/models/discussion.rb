class Discussion < ApplicationRecord
  include Pid
  belongs_to  :discussable, polymorphic: true
  belongs_to  :author, class_name: :User
  has_many    :comments, dependent: :destroy

  validates :topic,       length: { maximum: 255 }

end
