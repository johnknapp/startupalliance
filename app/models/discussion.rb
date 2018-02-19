class Discussion < ApplicationRecord
  include Pid

  belongs_to  :discussable, polymorphic: true
  belongs_to  :author, class_name: :User
  has_many    :topics, dependent: :destroy

  validates :name,       length: { maximum: 140 }

end
