class AddTwitterProfile < ActiveRecord::Migration
  def self.up
    add_column :profiles, :twitter_username, :string
    add_column :profiles, :twitter_password, :string
    add_column :profiles, :twitter_active, :boolean
  end

  def self.down
    remove_column :profiles, :twitter_username
    remove_column :profiles, :twitter_password
    remove_column :profiles, :twitter_active
  end
end
