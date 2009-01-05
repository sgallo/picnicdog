class CreateWeights < ActiveRecord::Migration
  def self.up
    create_table :weights do |t|
      t.integer :food_id
      t.integer :subcode_id
      t.integer :sequence
      t.integer :portion_id
      t.datetime :start_date
      t.datetime :end_date
      t.decimal :weight
      t.string :change_type
      t.timestamps
    end
  end

  def self.down
    drop_table :weights
  end
end
