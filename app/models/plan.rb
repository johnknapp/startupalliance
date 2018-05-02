class Plan < ApplicationRecord
  has_many :users
  has_many :invoices
  has_many :offers

  def duration
    self.name.split('_').last
  end

  def short_name
    self.name.split('_').second # TODO watch out for future plan name changes
  end

end
