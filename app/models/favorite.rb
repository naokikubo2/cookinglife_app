class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :food_record
end
