class RemoveTimeFromFoodShare < ActiveRecord::Migration[6.0]
  def change
    remove_column :food_shares, :limit_time, :time
    remove_column :food_shares, :give_time, :time
  end
end
