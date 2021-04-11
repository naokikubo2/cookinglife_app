class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :food_record

  validates :user_id, uniqueness: { scope: :food_record_id }

  def self.liked_users(id)
    ids = Favorite.where(food_record_id: id).pluck(:user_id)
    User.where(id: ids)
  end
end
