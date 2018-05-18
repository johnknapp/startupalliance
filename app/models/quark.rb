class Quark < ApplicationRecord
  include Pid
  include Search

  belongs_to :author, class_name: :User

end
