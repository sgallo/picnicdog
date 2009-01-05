class CreateRecipeComments < ActiveRecord::Migration
  def self.up
    create_table :recipe_comments do |t|
      t.integer :recipe_id
      t.integer :user_id
      t.text :the_comment
      t.decimal :rating
      t.timestamps
    end
  end

  def self.down
    drop_table :recipe_comments
  end
end
