class Page < ApplicationRecord
  include Pid
  include Search

  define_model_callbacks :around_audit

  # https://www.krautcomputing.com/blog/2015/01/13/recalculate-counter-cache-columns-in-rails/
  belongs_to  :author,  class_name: :User, counter_cache: true
  has_many    :audits,  as: :auditable, dependent: :destroy                   # dependent destroy doesn't work. See nuke rake

  validates :title,       presence: true
  validates :title,       length: { maximum: 64 }
  validates :content,     presence: true
  validates :content,     length: { maximum: 9216 }


  acts_as_votable
  acts_as_paranoid
  acts_as_ordered_taggable_on :categories
  audited only: [:title, :content, :category_list, :created_at, :updated_at], on: [:create, :update] # :destroy not needed

  scope :published, -> { where(state: 'Published') }

  # Inspired by https://github.com/collectiveidea/audited/issues/1
  # The objective is to audit changes in the Category tags. TODO the issue is still not quite solved
  def around_audit
    current_audit = yield
    if current_audit.action.eql?('create')
      current_audit.audited_changes['category_list'] = category_list.join(', ')
      current_audit.save
    elsif current_audit.action.eql?('update')
      current_audit.audited_changes['category_list'] = category_list.join(', ')
      current_audit.save
    elsif current_audit.audited_changes.key?('category_list')
      current_audit.audited_changes['category_list'] = category_list.join(', ')
      current_audit.save
    end
  end

end
