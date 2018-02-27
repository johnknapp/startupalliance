class Audit < ApplicationRecord

  # https://www.krautcomputing.com/blog/2015/01/13/recalculate-counter-cache-columns-in-rails/
  belongs_to  :user, counter_cache: true
  belongs_to  :auditable, polymorphic: true

end