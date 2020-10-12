class Post < ApplicationRecord
  belongs_to :user
  has_many :likes
  default_scope { order(created_at: :desc) }
end
