class AddOldTableIndexes < ActiveRecord::Migration
  def self.up
    add_index :comments, :meal_id
    add_index :comments, :user_id
    add_index :friendships, :user_id
    add_index :friendships, :friend_id
    add_index :invite_lists, :user_id
    add_index :invite_lists, :invitation_id
    add_index :invite_users, :invite_id
    add_index :invite_users, :user_id
    add_index :meals, :user_id
    add_index :profiles, :user_id
    add_index :ratings, :user_id
    add_index :ratings, :meal_id
    add_index :recipe_comments, :recipe_id
    add_index :recipe_comments, :user_id
    add_index :recipe_ratings, :user_id
    add_index :recipe_ratings, :recipe_id
    add_index :recipe_steps, :recipe_id
    add_index :recipes, :meal_id
    add_index :recipes, :user_id
    add_index :tastings, :user_id
    add_index :tastings, :meal_id
    add_index :user_weights, :user_id
    
  end

  def self.down
    remove_index :comments, :meal_id
    remove_index :comments, :user_id
    remove_index :friendships, :user_id
    remove_index :friendships, :friend_id
    remove_index :invite_lists, :user_id
    remove_index :invite_lists, :invitation_id
    remove_index :invite_users, :invite_id
    remove_index :invite_users, :user_id
    remove_index :meals, :user_id
    remove_index :profiles, :user_id
    remove_index :ratings, :user_id
    remove_index :ratings, :meal_id
    remove_index :recipe_comments, :recipe_id
    remove_index :recipe_comments, :user_id
    remove_index :recipe_ratings, :user_id
    remove_index :recipe_ratings, :recipe_id
    remove_index :recipe_steps, :recipe_id
    remove_index :recipes, :meal_id
    remove_index :recipes, :user_id
    remove_index :tastings, :user_id
    remove_index :tastings, :meal_id
    remove_index :user_weights, :user_id
  end
end
