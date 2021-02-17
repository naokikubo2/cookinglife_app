class FoodShare < ApplicationRecord
  belongs_to :user
  belongs_to :food_record
  has_many :fs_comments, dependent: :destroy

  has_many :matchings, dependent: :destroy

  validates :food_name, presence: true, length: { maximum: 25 }
  validates :limit_number, numericality: { greater_than: 0, less_than: 6 }, presence: true
  validates :give_time, presence: true
  validates :limit_time, presence: true
  validates :memo, length: { maximum: 250 }
  validates :latitude, presence: true
  validates :longitude, presence: true
  validate :time_after_registration
  validate :time_before_give

  mount_uploader :image, ImageUploader

  def takes?(take_user)
    matchings.to_a.find { |matching| matching.user_id == take_user.id }.present?
  end

  def take(take_user_id)
    matchings.new(user_id: take_user_id, status: 'not_achieved').save!
  end

  def untake(take_user_id)
    matching_id = matchings.find_by(user_id: take_user_id).id
    matchings.destroy(matching_id)
  end

  def complete?(take_user)
    matchings.select { |n| n.status == "complete" && n.user_id == take_user.id }.present?
  end

  def any_uncomplete?
    # matchingの全てがcompleteになっていること。
    matchings.select { |n| n.status == "not_achieved" && n.food_share_id == id }.present?
  end

  def time_judgment
    l_time = limit_time
    g_time = give_time
    n_time = Time.zone.now
    flag_time = ""
    if n_time < l_time
      flag_time = "before"
    elsif l_time <= n_time && n_time < g_time
      flag_time = "active"
    elsif g_time <= n_time
      flag_time = "after"
    end
    flag_time
  end

  def self.mine_sorting(current_user)
    food_share_mine = current_user.food_shares

    # お裾分け前のお裾分け料理を抽出
    mine_before = food_share_mine.select { |n| n.limit_time > Time.zone.now }
    mine_notbefore = food_share_mine.select { |n| n.limit_time <= Time.zone.now }

    # お裾分け未達成のお裾分け料理を抽出
    array_undone = []
    array_done = []

    mine_notbefore.each do |f|
      all_count = f.matchings.count
      comp_count = f.matchings.select { |n| n.status == "complete" }.count
      if all_count == comp_count
        array_done.push(f.id)
      else
        array_undone.push(f.id)
      end
    end
    mine_done = FoodShare.select { |n| array_done.include?(n.id) }
    mine_undone = FoodShare.select { |n| array_undone.include?(n.id) }

    [mine_before, mine_undone, mine_done ]
  end

  def self.friend_sorting(current_user)
    # ログインユーザのお裾分け希望しているマッチングを取得
    matchings_mine = current_user.matchings

    # マッチングからfood_share_idを射影
    array_matchings = matchings_mine.pluck(:food_share_id)

    # food_shareの中で、ログインユーザがお裾分け希望を出しているもののみ抽出
    food_share_friend_matching = self.select { |n| array_matchings.include?(n.id) }

    # お裾分け未達成のお裾分け料理を抽出
    array_undone = []
    food_share_friend_matching.to_a.each do |f|
      array_undone.push(f.id) if f.matchings.where(status: "not_achieved", user_id: current_user.id).any?
    end
    friend_undone = FoodShare.select { |n| array_undone.include?(n.id) }

    # お裾分け前のお裾分け料理を抽出
    # お裾分け期間前 かつ お裾分け希望を出していないもの
    food_share_friend_unmatching = select { |n| !array_matchings.include?(n.id) }
    array_before = []
    food_share_friend_unmatching.to_a.each do |f|
      array_before.push(f.id) if f.limit_time > Time.zone.now
    end
    friend_before = FoodShare.select { |n| array_before.include?(n.id) }

    # お裾分け実施済みのお裾分け料理を抽出
    array_done = []
    food_after = food_share_friend_matching.select { |n| n.limit_time < Time.zone.now }
    food_after.to_a.each do |f|
      match = f.matchings
      array_done.push(f.id) unless match.where(status: "not_achieved", user_id: current_user.id).any? && match.exists?(food_share_id: f.id)
    end
    friend_done = FoodShare.select { |n| array_done.include?(n.id) }

    [friend_before, friend_undone, friend_done]
  end
end

def time_after_registration
  errors.add(:give_time, 'は、現在より24時間以上先の日時を入力して下さい') if !give_time.nil? && (give_time < Time.zone.now + 24 * 60 * 60)
end

def time_before_give
  errors.add(:limit_time, 'は、お裾分け時間より12時間以上前の日時を入力して下さい') if !limit_time.nil? && !give_time.nil? && (give_time < limit_time + 12 * 60 * 60)
end
