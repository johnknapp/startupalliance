class Quark < ApplicationRecord
  include Pid

  belongs_to :author, class_name: :User

end
