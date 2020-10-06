class AddPrimaryKeyConstraintToFriends < ActiveRecord::Migration[6.0]
  def up
    execute 'ALTER TABLE friendships ADD PRIMARY KEY (user_id, friend_id);'
  end

  def down
    execute 'ALTER TABLE friendships DROP CONSTRAINT friendships_pkey;'
  end
end
