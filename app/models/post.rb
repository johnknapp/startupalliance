class Post < ApplicationRecord
  include Pid
  belongs_to  :discussion
  belongs_to  :author, class_name: :User
end
