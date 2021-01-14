FactoryBot.define do
  factory :fs_comment do
    association :user
    association :food_share
    content { "test" }
  end
end
