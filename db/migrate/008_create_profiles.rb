class CreateProfiles < ActiveRecord::Migration
  def self.up
    create_table :profiles do |t|
      t.string :user_id
      t.string :image_location
      t.string :about
      t.string :location
      t.string :full_name
      t.timestamps
    end
  end

  def self.down
    drop_table :profiles
  end
end
