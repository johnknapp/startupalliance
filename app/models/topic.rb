class Topic < ApplicationRecord
  include Pid

  acts_as_paranoid

  belongs_to  :discussion
  belongs_to  :author,  class_name: :User
  has_many    :posts,   dependent: :destroy

  validates :name,          length: { maximum: 140 }

  scope :fresh_posts_first, -> { includes(:posts).order('posts.updated_at desc') }

end
