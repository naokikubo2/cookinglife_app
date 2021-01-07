class AddUniqueIndexToMatchings < ActiveRecord::Migration[6.0]
  def change
    add_index :matchings, [:food_share_id, :user_id], unique: true
  end
end
