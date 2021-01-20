class CreateCities < ActiveRecord::Migration[6.0]
  def change
    create_table :cities do |t|
      t.string :name
      t.integer :location_id
      t.float :lon
      t.float :lat
      t.timestamps
    end
  end
end
