class Post < ApplicationRecord
  include Pid
  include PgSearch
  multisearchable against: [:body]

  has_ancestry
  acts_as_paranoid
  acts_as_readable on: :created_at # vs updated_at. see https://github.com/ledermann/unread

  belongs_to  :discussion
  belongs_to  :topic
  belongs_to  :author,      class_name: :User, counter_cache: true

  validates :body, length: { maximum: 2048 }

end
