class ChangeEmailColumn < ActiveRecord::Migration
  def self.up
    rename_column :emails, :email, :email_address
  end

  def self.down
    rename_column :emails, :email_address, :email
  end
end
