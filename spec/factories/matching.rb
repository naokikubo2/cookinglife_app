FactoryBot.define do
  factory :matching do
    association :food_share
    user { food_share.user }
    status { "not_achieved" }
  end
end
