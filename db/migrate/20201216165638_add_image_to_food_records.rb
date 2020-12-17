class AddImageToFoodRecords < ActiveRecord::Migration[6.0]
  def change
    add_column :food_records, :image, :string
  end
end
