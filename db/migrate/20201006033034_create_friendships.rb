class CreateFriendships < ActiveRecord::Migration[6.0]
  def change
    create_table :friendships, id: false do |t|
      t.belongs_to :user, null: false, foreign_key: true, index: true
      t.belongs_to :friend, null: false, foreign_key: { to_table: 'users' }, index: true

      t.timestamps
    end
  end
end
