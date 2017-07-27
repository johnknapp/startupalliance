class Post < ApplicationRecord
  include Pid
  belongs_to :discussion
end
