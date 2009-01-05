class AddProfileTotals < ActiveRecord::Migration
  def self.up
    add_column :profiles, :health_avg, :float, :default => 0
    add_column :profiles, :taste_avg, :float, :default => 0
    add_column :profiles, :comments_with_ratings_total, :integer, :default => 0
  end

  def self.down
    remove_column :profiles, :health_avg
    remove_column :profiles, :taste_avg
    remove_column :profiles, :comments_with_ratings_total
  end
end
