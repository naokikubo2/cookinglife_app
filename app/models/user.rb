class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true, uniqueness: true, length: { maximum: 20 }

  has_many :food_records, dependent: :destroy
  has_many :food_shares, dependent: :destroy
  has_many :relationships, dependent: :destroy
  has_many :followings, through: :relationships, source: :follow
  has_many :reverse_of_relationships, class_name: 'Relationship', foreign_key: 'follow_id', dependent: :destroy
  has_many :followers, through: :reverse_of_relationships, source: :user

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
end
