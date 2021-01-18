class AddColumnFoodRecords < ActiveRecord::Migration[6.0]
  def change
    add_column :food_records, :weather_id, :integer
    add_column :food_records, :weather_main, :string
    add_column :food_records, :weather_description, :string
    add_column :food_records, :weather_icon, :string
    add_column :food_records, :temp, :float
    add_column :food_records, :temp_max, :float
    add_column :food_records, :temp_min, :float
    add_column :food_records, :pressure, :integer
    add_column :food_records, :humidity, :integer
  end
end
