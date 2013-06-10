class CreateFriendships < ActiveRecord::Migration
  using(:master)
  def change
    create_table :friendships do |t|
      t.integer :user_id
      t.integer :friend_id

      t.timestamps
    end
  end
end
