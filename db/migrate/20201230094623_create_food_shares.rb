class CreateFoodShares < ActiveRecord::Migration[6.0]
  def change
    create_table :food_shares do |t|
      t.string :food_name
      t.time :limit_time
      t.integer :limit_number
      t.time :give_time


      t.references :user, null: false, foreign_key: true
      t.references :food_record, null: false, foreign_key: true

      t.timestamps
    end
  end
end
