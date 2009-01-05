class AddEmailSubscriptionColumn < ActiveRecord::Migration
  def self.up
    add_column :emails, :subscription, :integer, :default => 0
  end

  def self.down
    remove_column :emails, :subscription, :integer, :default => 0
  end
end
