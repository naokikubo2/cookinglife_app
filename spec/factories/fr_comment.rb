FactoryBot.define do
  factory :fr_comment do
    association :user
    association :food_record
    content { "test" }
  end
end
