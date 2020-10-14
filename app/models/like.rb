class Like < ApplicationRecord
  self.primary_keys = %i[user_id post_id]
  belongs_to :user
  belongs_to :post
end
