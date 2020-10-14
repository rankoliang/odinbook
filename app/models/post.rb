class Post < ApplicationRecord
  belongs_to :user
  has_many :likes, dependent: :destroy
  default_scope { order(created_at: :desc) }

  def self.feed(current_user)
    friends(current_user).or(Post.where('user_id = ?', current_user.id))
  end

  def self.friends(current_user)
    where('user_id in (:friends)', friends: current_user.friends.select(&:id))
  end

  def num_likes
    likes.count
  end
end
