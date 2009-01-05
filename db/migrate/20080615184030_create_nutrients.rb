class CreateNutrients < ActiveRecord::Migration
  def self.up
    create_table :nutrients do |t|
      t.string :description
      t.string :tagname
      t.string :unit
      t.integer :decimals
      t.timestamps
    end
  end

  def self.down
    drop_table :nutrients
  end
end
