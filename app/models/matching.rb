class Matching < ApplicationRecord
  belongs_to :user
  belongs_to :food_share

  validates :food_share_id, uniqueness: { scope: :user_id }
  validate :safe_limit_number

  def safe_limit_number
    errors.add(:food_share_id, 'は募集人数を超過しています') unless (food_share.limit_number - food_share.matchings.count).positive?
  end
end
