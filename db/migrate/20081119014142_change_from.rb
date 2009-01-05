class ChangeFrom < ActiveRecord::Migration
  def self.up
    drop_table :nutrients
    drop_table :foods
    drop_table :food_nutrients
    drop_table :weights
    drop_table :portions

    create_table :foods do |t|
      t.string :food_group_id
      t.string :description
      t.string :short_description
      t.string :common_name
      t.string :manufacturer
      t.string :survey
      t.string :ref_desc
      t.string :refuse
      t.string :sci_name
      t.string :n_factor
      t.string :pro_factor
      t.string :fat_factor
      t.string :cho_factor
      t.timestamps
    end

    add_index :foods, :food_group_id
    
    create_table :nutrients do |t|
      t.string :units
      t.string :tagname
      t.string :description
      t.integer :decimal
      t.integer :sr_order
      t.timestamps
    end

    create_table :nutrient_datas do |t|
      t.integer :food_id
      t.integer :nutrient_id
      t.decimal :nutr_val, :precision => 20, :scale => 10
    end

    add_index :nutrient_datas, :food_id
    add_index :nutrient_datas, :nutrient_id

    create_table :weights do |t|
      t.integer :food_id
      t.integer :seq
      t.decimal :amount
      t.string :msre_desc
      t.decimal :gm_wgt, :precision => 8, :scale => 4
    end

    add_index :weights, :food_id

    execute "ALTER TABLE foods type myisam"
    execute "ALTER TABLE foods ADD FULLTEXT(description)"
    
  end

  def self.down
    drop_table :nutrients
    drop_table :foods
    drop_table :nutrient_datas
    drop_table :weights
    create_table :foods do |t|
      t.datetime :start_date
      t.datetime :end_date
      t.string :description
      t.string :abbreviated_description
      t.timestamps
    end
    create_table :food_nutrients do |t|
      t.integer :food_id
      t.integer :nutrient_id
      t.datetime :start_date
      t.datetime :end_date
      t.decimal :nutrient_value
      t.timestamps
    end
    create_table :nutrients do |t|
      t.string :description
      t.string :tagname
      t.string :unit
      t.integer :decimals
      t.timestamps
    end
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
    create_table :portions do |t|
      t.datetime :start_date
      t.datetime :end_date
      t.string :description
      t.string :change_type
      t.timestamps
    end

  end
end
