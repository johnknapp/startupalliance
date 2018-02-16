class Topic < ApplicationRecord
  include Pid

  belongs_to  :discussion
  belongs_to  :author,  class_name: :User
  has_many    :posts,   dependent: :destroy

  validates :name,          length: { maximum: 255 }

end
