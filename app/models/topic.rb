class Topic < ApplicationRecord
  include Pid

  belongs_to  :discussion
  belongs_to  :author,  class_name: :User
  has_many    :posts,   dependent: :destroy

  validates :name,          length: { maximum: 255 }

  scope :fresh_posts_first, -> { includes(:posts).order('posts.updated_at desc') }

end
