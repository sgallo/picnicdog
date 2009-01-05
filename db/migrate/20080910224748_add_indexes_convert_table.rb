class AddIndexesConvertTable < ActiveRecord::Migration
  def self.up
    execute "ALTER TABLE foods type myisam"
    execute "ALTER TABLE foods ADD FULLTEXT(description)"
    add_index :weights, :portion_id
    add_index :weights, :food_id
    add_index :food_nutrients, :food_id
    add_index :food_nutrients, :nutrient_id
  end

  def self.down
    remove_index :weights, :portion_id
    remove_index :weights, :food_id
    remove_index :food_nutrients, :food_id
    remove_index :food_nutrients, :nutrient_id
    execute "ALTER TABLE foods DROP INDEX description"
    execute "ALTER TABLE foods type innodb"
  end
end
