class FactStrat < ApplicationRecord
  belongs_to :fast
  belongs_to :strategy, class_name: :Fast
end
