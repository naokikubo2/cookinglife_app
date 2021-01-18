class AddUniqueIndexToFavorite < ActiveRecord::Migration[6.0]
  def change
    add_index :favorites, [:food_record_id, :user_id], unique: true
  end
end
