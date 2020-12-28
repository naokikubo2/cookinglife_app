class AddFoodDateToFoodRecord < ActiveRecord::Migration[6.0]
  def change
    add_column :food_records, :food_date, :date
  end
end
