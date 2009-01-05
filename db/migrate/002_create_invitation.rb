class CreateInvitation < ActiveRecord::Migration
  def self.up
    create_table :invitations do |t|
      t.string :code
      t.integer :reciever_user_id
      t.integer :sender_user_id
      t.integer :count
      t.string :reciever_email
      t.timestamps
    end
  end

  def self.down
    drop_table :invitations
  end
end
