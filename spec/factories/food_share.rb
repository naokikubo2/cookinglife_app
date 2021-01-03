FactoryBot.define do
  factory :food_share do
    association :user
    association :food_record
    food_name { "food" }
    limit_number { 3 }
    limit_time { DateTime.now + 24 * 3600 }
    give_time { DateTime.now + 48 * 3600 }
  end
end
