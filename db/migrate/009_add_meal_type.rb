class AddMealType < ActiveRecord::Migration
  def self.up
    add_column :meals, :meal_type, :string
  end

  def self.down
    remove_column :meals, :meal_type
  end
end
