class FoodShare < ApplicationRecord
  belongs_to :user
  belongs_to :food_record

  has_many :matchings, dependent: :destroy

  validates :food_name, presence: true, length: { maximum: 25 }
  validates :limit_number, numericality: { greater_than: 0, less_than: 6 }, presence: true
  validates :give_time, presence: true
  validates :limit_time, presence: true
  validates :memo, length: { maximum: 250 }
  validate :time_after_registration
  validate :time_before_give

  mount_uploader :image, ImageUploader

  def takes?(take_user)
    matchings.to_a.find { |matching| matching.user_id == take_user.id }.present?
  end

  def take(take_user_id)
    matchings.new(user_id: take_user_id).save!
  end

  def untake(take_user_id)
    matching_id = matchings.find_by(user_id: take_user_id).id
    matchings.destroy(matching_id)
  end
end

def time_after_registration
  errors.add(:give_time, 'は、現在より24時間以上先の日時を入力して下さい') if !give_time.nil? && (give_time < Time.zone.now + 24 * 60 * 60)
end

def time_before_give
  errors.add(:limit_time, 'は、お裾分け時間より12時間以上前の日時を入力して下さい') if !limit_time.nil? && !give_time.nil? && (give_time < limit_time + 12 * 60 * 60)
end
