class Fastr < ApplicationRecord
  belongs_to :fast
  belongs_to :strategy, class_name: :Fast, dependent: :destroy
end
