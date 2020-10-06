class AddPrimaryKeyConstraintToFriendRequests < ActiveRecord::Migration[6.0]
  def up
    execute 'ALTER TABLE friend_requests ADD PRIMARY KEY (requester_id, requestee_id);'
  end

  def down
    execute 'ALTER TABLE friend_requests DROP CONSTRAINT friend_requests_pkey;'
  end
end
