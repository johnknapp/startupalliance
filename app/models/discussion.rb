class Discussion < ApplicationRecord
  include Pid
  belongs_to  :discussable, polymorphic: true
  has_many    :posts, dependent: :destroy
end
