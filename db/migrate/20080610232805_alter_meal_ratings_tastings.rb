class AlterMealRatingsTastings < ActiveRecord::Migration
  def self.up
    change_column :meals, :rating, :float
    change_column :meals, :tasting, :float
  end

  def self.down
  end
end
