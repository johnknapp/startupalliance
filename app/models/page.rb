class Page < ApplicationRecord
  include Pid

  validates :title,       presence: true, on: :create
  validates :title,       length: { maximum: 64 }
  validates :content,     length: { maximum: 3072 }

  audited only: [:title, :content]
  acts_as_paranoid
  acts_as_ordered_taggable_on :categories

end
