class CreateFoodNutrients < ActiveRecord::Migration
  def self.up
    create_table :food_nutrients do |t|
      t.integer :food_id
      t.integer :nutrient_id
      t.datetime :start_date
      t.datetime :end_date
      t.decimal :nutrient_value
      t.timestamps
    end
  end

  def self.down
    drop_table :food_nutrients
  end
end
