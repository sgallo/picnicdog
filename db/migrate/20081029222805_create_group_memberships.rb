class CreateGroupMemberships < ActiveRecord::Migration
  def self.up
    create_table :group_memberships do |t|
      t.integer :group_id, :user_id
      t.timestamps
    end
  end

  def self.down
    drop_table :group_memberships
  end
end
