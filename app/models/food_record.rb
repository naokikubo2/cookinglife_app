class FoodRecord < ApplicationRecord
  belongs_to :user

  validates :user_id, presence: true
  validates :food_name, length: { maximum: 25 }
  validates :healthy_score, :numericality => { :less_than_or_equal_to => 5, :more_than_or_equal_to => 0 } , allow_nil: true
  validates :total_score, :numericality => { :less_than_or_equal_to => 5, :more_than_or_equal_to => 0 } , allow_nil: true
  validates :workload_score, :numericality => { :less_than_or_equal_to => 5, :more_than_or_equal_to => 0} , allow_nil: true
  validates :memo, length: { maximum: 250 }
end
