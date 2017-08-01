class Message < ApplicationRecord
  include Pid

  belongs_to :conversation
  belongs_to :author, foreign_key: :user_id, class_name: 'User'

  validates_presence_of :body, :conversation_id, :user_id

end