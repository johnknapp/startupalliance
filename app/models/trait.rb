class Trait < ApplicationRecord
  has_many  :user_traits
  has_many  :users, through: :user_traits
end
