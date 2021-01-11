class FsComment < ApplicationRecord
  belongs_to :user
  belongs_to :food_share
  validates :content, presence: true
end
