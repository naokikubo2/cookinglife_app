class AddDateTimeToFoodShares < ActiveRecord::Migration[6.0]
  def change
    add_column :food_shares, :give_time, :datetime
    add_column :food_shares, :limit_time, :datetime
  end
end
