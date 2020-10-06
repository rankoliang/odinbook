class CreateFriendRequests < ActiveRecord::Migration[6.0]
  def change
    create_table :friend_requests, id: false do |t|
      t.belongs_to :requester, null: false, foreign_key: { to_table: :users }, index: true
      t.belongs_to :requestee, null: false, foreign_key: { to_table: :users }, index: true

      t.timestamps
    end
  end
end
