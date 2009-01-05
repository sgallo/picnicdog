class AddInvalidEmailUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :invalid_email, :integer, :default => 0
  end

  def self.down
    remove_column :users, :invalid_email
  end
end
