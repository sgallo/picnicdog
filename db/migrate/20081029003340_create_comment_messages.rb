class CreateCommentMessages < ActiveRecord::Migration
  def self.up
    create_table :comment_messages do |t|
      t.integer :comment_id, :user_id
      t.text :message
      t.timestamps
    end
  end

  def self.down
    drop_table :comment_messages
  end
end
