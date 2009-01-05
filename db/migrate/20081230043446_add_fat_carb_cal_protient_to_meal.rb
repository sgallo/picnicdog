class AddFatCarbCalProtientToMeal < ActiveRecord::Migration
  def self.up
    add_column :meals, :fat, :decimal, :precision => 20, :scale => 5
    add_column :meals, :calories, :decimal, :precision => 20, :scale => 5
    add_column :meals, :carbs, :decimal, :precision => 20, :scale => 5
    add_column :meals, :protein, :decimal, :precision => 20, :scale => 5
  end

  def self.down
    remove_column :meals, :fat
    remove_column :meals, :calories
    remove_column :meals, :carbs
    remove_column :meals, :protein
  end
end
