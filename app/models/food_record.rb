class FoodRecord < ApplicationRecord
  belongs_to :user
  has_many :food_shares, dependent: :destroy
  has_many :fr_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy

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

  def favorites?(favorite_user)
    favorites.to_a.find { |favorite| favorite.user_id == favorite_user.id }.present?
  end

  def like(favorite_user_id)
    favorites.new(user_id: favorite_user_id).save!
  end

  def unlike(favorite_user_id)
    favorite_id = favorites.find_by(user_id: favorite_user_id).id
    favorites.destroy(favorite_id)
  end

  def self.food_recommend(current_user)
    # ログインユーザの料理
    food_records_mine = current_user.food_records

    # ログインユーザの昨日の料理
    food_record_yesterday = food_records_mine.select { |n| n.food_date == Time.zone.today - 1 }

    # ログインユーザの直近1週間の料理
    food_record_week = food_records_mine.select { |n| n.food_date >= Time.zone.today - 7 }

    # 今日〜1週間のデータを除く
    food_record_past = food_records_mine.select { |n| n.food_date < Time.zone.today - 7 }

    # 前日の料理、麺かどうか判定
    flag_noodle = false
    food_record_yesterday.each do |food|
      next if food.tags.nil?

      food.tags.each do |var|
        flag_noodle = true if var.name.include?("麺")
      end
    end

    # 麺料理がある場合は麺料理を除外
    food_record_past = food_record_past.reject { |n| n.tag_list.include?("麺") } if flag_noodle

    # 直近1週間の料理名と一致するレコードを除外
    array_foodname = food_record_week.pluck(:food_name)
    food_record_past = food_record_past.reject { |n| array_foodname.include?(n.food_name) }

    # 料理の類似度を分析
    y_food = food_record_yesterday.pluck(:workload_score, :healthy_score)
    p_food = food_record_past.pluck(:workload_score, :healthy_score, :id)
    max_distance = 0
    max_id = 0
    p_food.each do |p|
      next unless max_distance < (p[0] - y_food[0][0])**2 + (p[1] - y_food[0][1])**2

      max_distance = (p[0] - y_food[0][0])**2 + (p[1] - y_food[0][1])**2
      max_id = p[2]
    end
    find_by(id: max_id)
  rescue StandardError => e
  end
end
