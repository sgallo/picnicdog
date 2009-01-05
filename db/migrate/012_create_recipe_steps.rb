class CreateRecipeSteps < ActiveRecord::Migration
  def self.up
    create_table :recipe_steps do |t|
      t.integer :recipe_id
      t.string :step
      t.integer :sort_order
      t.timestamps
    end
  end

  def self.down
    drop_table :recipe_steps
  end
end
