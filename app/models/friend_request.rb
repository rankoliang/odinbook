class FriendRequest < ApplicationRecord
  validates :requester, presence: true
  validates :requestee, presence: true, uniqueness: { scope: :requester, message: 'already sent a request'}
  validate :request_self

  self.primary_keys = %i[requester_id requestee_id]
  belongs_to :requester, class_name: 'User', foreign_key: 'requester_id'
  belongs_to :requestee, class_name: 'User', foreign_key: 'requestee_id'

  private

  def request_self
    errors.add(:requester, 'cannot request yourself') if requester == requestee
  end
end
