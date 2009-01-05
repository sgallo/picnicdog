class AddInviteCountProfile < ActiveRecord::Migration
  def self.up
    add_column "profiles", "invite_count", :integer, :default => 10
  end

  def self.down
    remove_column "profiles", "invite_count"
  end
end
