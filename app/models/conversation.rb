class Conversation < ApplicationRecord
  include Pid

  belongs_to :sender,     foreign_key: :sender_id,    class_name: 'User'
  belongs_to :recipient,  foreign_key: :recipient_id, class_name: 'User'

  has_many :messages,     dependent: :destroy

  validates_uniqueness_of :sender_id, :scope => :recipient_id

  default_scope { order(updated_at: :desc) }

  scope :between, -> (sender_id,recipient_id) do
    where('(conversations.sender_id = ? AND conversations.recipient_id = ?) OR (conversations.sender_id = ? AND conversations.recipient_id = ?)', sender_id, recipient_id, recipient_id, sender_id)
  end

  scope :includes?, -> (current_user) do
    where('sender_id = ? or recipient_id = ?', current_user.id, current_user.id).all
  end

end