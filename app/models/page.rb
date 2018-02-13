class Page < ApplicationRecord
  include Pid

  validates :title,       presence: true
  validates :title,       length: { maximum: 64 }
  validates :content,     presence: true
  validates :content,     length: { maximum: 3072 }

  acts_as_paranoid
  acts_as_ordered_taggable_on :categories
  audited only: [:title, :content, :created_at, :updated_at]

end
