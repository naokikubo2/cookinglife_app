class AddImageToFoodShare < ActiveRecord::Migration[6.0]
  def change
    add_column :food_shares, :image, :string
  end
end
