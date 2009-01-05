class AddProfileSystemEmailSetting < ActiveRecord::Migration
  def self.up
    add_column :profiles, :send_system_email, :integer, :default => 0
  end

  def self.down
    remove_column :profiles, :send_system_email
  end
end
