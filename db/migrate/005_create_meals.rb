class CreateMeals < ActiveRecord::Migration
  def self.up
    create_table :meals do |t|
      t.integer :user_id
      t.string :post
      t.integer :number_of_comments, :default => 0
      t.integer :number_of_recipes, :default => 0
      t.decimal :rating
      t.timestamps
    end
  end

  def self.down
    drop_table :meals
  end
end
