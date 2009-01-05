class CreateMealFoods < ActiveRecord::Migration
  def self.up
    create_table :meal_foods do |t|
      t.integer :meal_id, :food_id, :weight_id, :quantity
      t.timestamps
    end
  end

  def self.down
    drop_table :meal_foods
  end
end
