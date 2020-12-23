class FoodRecord < ApplicationRecord
  belongs_to :user

  STATUS_VALUES = %w[morning lunch dinner snack].freeze

  validates :user_id, presence: true
  validates :image, presence: true
  validates :food_name, length: { maximum: 25 }
  validates :healthy_score, numericality: { greater_than: -5, less_than: 5 }, allow_nil: true
  validates :total_score, numericality: { greater_than: 0, less_than: 6 }, allow_nil: true
  validates :workload_score, numericality: { greater_than: -5, less_than: 5 }, allow_nil: true
  validates :memo, length: { maximum: 250 }
  validates :food_timing, inclusion: { in: STATUS_VALUES }, allow_nil: true

  mount_uploader :image, ImageUploader
end
