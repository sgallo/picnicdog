class CreateNotifications < ActiveRecord::Migration
  def self.up
    create_table :notifications do |t|
      t.integer :friend_id, :user_id, :object_id
      t.string :friend_name, :user_name, :o_type, :param_one, :param_two, :param_three, :param_four, :param_five, :params_six, :params_seven, :param_eight

      t.timestamps
    end
  end

  def self.down
    drop_table :notifications
  end
end
