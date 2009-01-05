class CreateUserInvite < ActiveRecord::Migration
  def self.up
    create_table :invite_users do |t|
      t.integer :invite_id
      t.integer :user_id
    end
  end

  def self.down
    drop_table :invite_users
  end
end
