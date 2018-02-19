class Post < ApplicationRecord
  include Pid

  has_ancestry
  acts_as_paranoid

  belongs_to  :topic
  belongs_to  :author,      class_name: :User

  validates :body, length: { maximum: 2048 }

end
