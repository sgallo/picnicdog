class CreatePortions < ActiveRecord::Migration
  def self.up
    create_table :portions do |t|
      t.datetime :start_date
      t.datetime :end_date
      t.string :description
      t.string :change_type
      t.timestamps
    end
  end

  def self.down
    drop_table :portions
  end
end
