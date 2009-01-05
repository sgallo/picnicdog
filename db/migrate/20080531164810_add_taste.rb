class AddTaste < ActiveRecord::Migration
  def self.up
    
    add_column :comments, :tasting, :integer
    add_column :meals, :tasting, :decimal
      
    create_table :tastings do |t|
      t.integer :user_id
      t.integer :meal_id
      t.integer :tasting
      t.timestamps
    end
  end

  def self.down
    remove_column :comments, :tasting
    remove_column :meals, :tasting
  end
end
