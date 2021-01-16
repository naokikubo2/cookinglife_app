FactoryBot.define do
  factory :favorite do
    association :food_record
    association :user
  end
end
