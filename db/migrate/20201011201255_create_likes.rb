class CreateLikes < ActiveRecord::Migration[6.0]
  def change
    create_table :likes, id: false do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.belongs_to :post, null: false, foreign_key: true

      t.timestamps
    end
  end

  def up
    execute 'ALTER TABLE likes ADD PRIMARY KEY (user_id, post_id);'
  end

  def down
    execute 'ALTER TABLE likes DROP CONSTRAINT likes_pkey;'
  end
end
