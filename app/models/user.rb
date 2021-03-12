class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true, uniqueness: true, length: { maximum: 20 }
  validates :location_id, presence: true
  validates :address, presence: true

  geocoded_by :address
  after_validation :geocode, if: :address_changed?

  has_many :food_records, dependent: :destroy
  has_many :food_shares, dependent: :destroy
  has_many :relationships, dependent: :destroy
  has_many :followings, through: :relationships, source: :follow
  has_many :reverse_of_relationships, class_name: 'Relationship', foreign_key: 'follow_id', dependent: :destroy
  has_many :followers, through: :reverse_of_relationships, source: :user

  has_many :matchings, dependent: :destroy
  has_many :fr_comments, dependent: :destroy
  has_many :fs_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy

  mount_uploader :image, ImageUploader

  def follow(other_user_id)
    relationships.find_or_create_by(follow_id: other_user_id) unless id == other_user_id.to_i
  end

  def unfollow(other_user_id)
    relationship = relationships.find_by(follow_id: other_user_id)
    relationship.destroy if relationship
  end

  def following?(other_user)
    followings.include?(other_user)
  end

  def friends
    followings & followers
  end

  def food_shares_friends
    friends_ids = User.where(id: reverse_of_relationships.select(:user_id))
                      .where(id: relationships.select(:follow_id)).pluck(:id)
    FoodShare.where(user_id: friends_ids)
  end

  def food_records_followings
    user_ids = Relationship.where(user_id: id).pluck(:follow_id)
    FoodRecord.where(user_id: user_ids)
  end

  def self.guest
    find_or_create_by!(email: 'email@guest.com') do |user|
      user.name = "ゲスト"
      user.password = SecureRandom.urlsafe_base64
      # user.confirmed_at = Time.now  # Confirmable を使用している場合は必要
      user.location_id = 1_850_147
      user.address = '東京'
      user.latitude = 35.7090259
      user.longitude = 139.7319925
    end
  end
end
