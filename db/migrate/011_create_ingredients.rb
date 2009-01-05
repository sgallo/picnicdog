class CreateIngredients < ActiveRecord::Migration
  def self.up
    create_table :ingredients do |t|
      t.integer :recipe_id
      t.string :ingredient
      t.integer :sort_order
      t.timestamps
    end
  end

  def self.down
    drop_table :ingredients
  end
end
