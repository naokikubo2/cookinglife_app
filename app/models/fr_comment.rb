class FrComment < ApplicationRecord
  belongs_to :user
  belongs_to :food_record
  validates :content, presence: true
end
