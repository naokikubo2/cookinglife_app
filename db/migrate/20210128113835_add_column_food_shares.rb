class AddColumnFoodShares < ActiveRecord::Migration[6.0]
  def change
    add_column :food_shares, :latitude, :float, null: false
    add_column :food_shares, :longitude, :float, null: false
  end
end
