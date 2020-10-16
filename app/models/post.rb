class Post < ApplicationRecord
  belongs_to :user
  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy
  default_scope { includes(comments: [user: :avatar_attachment], likes: :user, user: %i[avatar_attachment]).order(created_at: :desc) }

  def self.feed(current_user, page: 1, per_page: 7)
    friends(current_user).paginate(page: page, per_page: per_page) if current_user
  end

  def self.friends(current_user)
    where('user_id in (:friends, :current_user)', friends: current_user.friends.select(&:id), current_user: current_user.id)
  end

  def num_likes
    likes.length
  end
end
