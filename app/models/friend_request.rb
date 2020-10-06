class FriendRequest < ApplicationRecord
  validates :requester, presence: true
  validates :requestee, presence: true

  self.primary_keys = %i[requester_id requestee_id]
  belongs_to :requester, class_name: 'User', foreign_key: 'requester_id'
  belongs_to :requestee, class_name: 'User', foreign_key: 'requestee_id'
end
