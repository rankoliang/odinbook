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
end
