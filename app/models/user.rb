require 'open-uri'

class User < ApplicationRecord
  validates :name, presence: true, length: { maximum: 26 }
  validates :summary, length: { maximum: 200 }

  has_one_attached :avatar, dependent: :destroy
  has_many :friend_requests, class_name: 'FriendRequest',
                             foreign_key: 'requestee_id',
                             dependent: :destroy
  has_many :sent_requests, class_name: 'FriendRequest',
                           foreign_key: 'requester_id',
                           dependent: :destroy

  has_many :requestees, through: :sent_requests
  has_many :requesters, through: :friend_requests

  has_many :friendships, dependent: :destroy

  has_many :friends, class_name: 'User',
                     through: :friendships,
                     foreign_key: 'friend_id'

  default_scope { order(:name).with_attached_avatar }

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :omniauthable, omniauth_providers: %i[discord]

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      info = auth.info

      user.email = info.email
      user.password = Devise.friendly_token[0, 20]
      user.name = info.name
      user.attach_avatar_from_url info.image if info.image.present?

      user.skip_confirmation!
    end
  end

  def attach_avatar_from_url(avatar_url)
    picture = OpenStruct.new(io: URI.open(avatar_url), ext: File.extname(avatar_url))
    file_base_tokens = name.scan(/\w+/)
    file_base_name = file_base_tokens.join('_')
    filename = file_base_name + picture.ext

    avatar.attach(io: picture.io, filename: filename)
  end

  def request_to_be_friends(user)
    sent_requests.create(requestee: user)
  end

  def friend_request_from(user)
    friend_requests.find_by(requester: user)
  end

  def friend_request_to(user)
    sent_requests.find_by(requestee: user)
  end

  def accept_friend_request_from(other_user)
    request = friend_request_from(other_user)
    return unless request

    Friendship.transaction do
      FriendRequest.transaction do
        request.destroy
        friendships.create(friend: other_user)
      end
    end
  end

  def cancel_request(requestee)
    friend_request_to(requestee)&.destroy
  end

  def requestable_friends
    User.where('id NOT IN (:friends)', friends: friends.select(:id))
        .where('id NOT IN (:requestees)', requestees: requestees.select(:id))
        .where('id NOT IN (:requesters)', requesters: requesters.select(:id))
        .where('id != ?', id)
  end

  def add_friend(friend)
    friendships.create(friend: friend)
  end

  def remove_friend(friend)
    friendship = friendships.find_by(friend: friend)
    friendship&.destroy
  end

  # returns the relationship of the other user to self
  def relationship(user)
    if self == user
      :self
    elsif sent_requests.find_by(requestee_id: user.id)
      :requestee
    elsif friend_requests.find_by(requester_id: user.id)
      :requester
    elsif friendships.find_by(friend_id: user.id)
      :friend
    end
  end
end
