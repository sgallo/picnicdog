class CreateFriendships < ActiveRecord::Migration
  def self.up
    
    create_table :friendships do |t|
      t.integer :user_id, :friend_id
      t.timestamps
    end
  end

  def self.down
    drop_table :friendships
    create_table :friends do |t|
      t.integer :user_id, :friend_id
      t.timestamps
    end
  end
end
