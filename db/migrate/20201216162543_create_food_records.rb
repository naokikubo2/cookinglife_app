class CreateFoodRecords < ActiveRecord::Migration[6.0]
  def change
    create_table :food_records do |t|
      t.references :user, null: false, foreign_key: true
      t.string :food_name
      t.integer :healthy_score
      t.integer :total_score
      t.integer :workload_score
      t.integer :food_timing
      t.text :memo

      t.timestamps
    end
  end
end
