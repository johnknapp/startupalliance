class Page < ApplicationRecord
  include Pid

  define_model_callbacks :around_audit

  validates :title,       presence: true
  validates :title,       length: { maximum: 64 }
  validates :content,     presence: true
  validates :content,     length: { maximum: 9216 }

  acts_as_paranoid
  acts_as_ordered_taggable_on :categories
  audited only: [:title, :content, :category_list, :created_at, :updated_at]

  # Inspired by https://github.com/collectiveidea/audited/issues/1
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
