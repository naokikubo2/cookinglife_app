class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :food_record

  validates :user_id, uniqueness: { scope: :food_record_id }
end
