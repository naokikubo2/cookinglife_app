class AddEatingOutToFoodRecords < ActiveRecord::Migration[6.0]
  def change
    add_column :food_records, :eating_out, :boolean, default: false, null: false
  end
end
