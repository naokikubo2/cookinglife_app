class AddMemoToFoodShare < ActiveRecord::Migration[6.0]
  def change
    add_column :food_shares, :memo, :text
  end
end
