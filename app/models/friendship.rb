class Friendship < ApplicationRecord
  validates :user, presence: true
  validates :friend, presence: true

  self.primary_keys = :user_id, :friend_id
  belongs_to :user
  belongs_to :friend, class_name: 'User'

  after_create :create_matching
  after_destroy :destroy_matching

  def matching
    self.class.find_by(user: friend, friend: user)
  end

  def create_matching
    return if matching

    self.class.create(user: friend, friend: user)
  end

  def destroy_matching
    matching&.destroy
  end
end
