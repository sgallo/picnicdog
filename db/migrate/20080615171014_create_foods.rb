class CreateFoods < ActiveRecord::Migration
  def self.up
    create_table :foods do |t|
      t.datetime :start_date
      t.datetime :end_date
      t.string :description
      t.string :abbreviated_description
      t.timestamps
    end
  end

  def self.down
    drop_table :foods
  end
end
