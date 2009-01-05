class ChangeRecipeStepToText < ActiveRecord::Migration
  def self.up
    change_column :recipe_steps, :step, :text
  end

  def self.down
    change_column :recipe_steps, :step, :string
  end
end
