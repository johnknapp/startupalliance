class Post < ApplicationRecord
  include Pid

  has_ancestry
  acts_as_paranoid
  acts_as_readable on: :created_at # unread gem SEE NOTE on github page about created_at vs updated_at

  belongs_to  :discussion
  belongs_to  :topic
  belongs_to  :author,      class_name: :User

  validates :body, length: { maximum: 2048 }

end
