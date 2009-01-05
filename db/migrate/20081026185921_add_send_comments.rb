class AddSendComments < ActiveRecord::Migration
  def self.up
    add_column :profiles, :send_comments, :integer, :default => 0
  end

  def self.down
    remove_column :profiles, :send_comments
  end
end
