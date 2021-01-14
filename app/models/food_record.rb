class FoodRecord < ApplicationRecord
  belongs_to :user
  has_many :food_shares, dependent: :destroy
  has_many :fr_comments, dependent: :destroy

  STATUS_VALUES = %w[morning lunch dinner snack].freeze

  validates :user_id, presence: true
  validates :image, presence: true
  validates :food_name, length: { maximum: 25 }
  validates :healthy_score, numericality: { greater_than: -5, less_than: 5 }, allow_nil: true
  validates :total_score, numericality: { greater_than: 0, less_than: 6 }, allow_nil: true
  validates :workload_score, numericality: { greater_than: -5, less_than: 5 }, allow_nil: true
  validates :memo, length: { maximum: 250 }
  validates :food_timing, inclusion: { in: STATUS_VALUES }, allow_blank: true
  validates :food_date, presence: true
  validate :day_after_today

  mount_uploader :image, ImageUploader
  acts_as_taggable_on :tags

  def day_after_today
    errors.add(:food_date, 'は、今日を含む過去の日付を入力して下さい') if !food_date.nil? && (food_date > Time.zone.today)
  end
end
