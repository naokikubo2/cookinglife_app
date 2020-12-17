class ChangeDataFoodTimingToFoodRecord < ActiveRecord::Migration[6.0]
  def change
    change_column :food_records, :food_timing, :string
  end
end
