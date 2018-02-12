class Page < ApplicationRecord
  include Pid

  has_many    :page_sakpis
  has_many    :sakpis, through: :page_sakpis, dependent: :destroy

  validates :title,       presence: true, on: :create
  validates :title,       length: { maximum: 64 }
  validates :content,     length: { maximum: 3072 }

  audited only: [:title, :content]
  acts_as_paranoid

end
