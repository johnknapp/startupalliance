class Plan < ApplicationRecord
  has_many :users
  has_many :invoices
  has_many :offers

  def duration
    self.name.split('_').last
  end

end
