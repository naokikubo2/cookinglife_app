FactoryBot.define do
  factory :matching do
    association :food_share
    user { food_share.user }
  end
end
