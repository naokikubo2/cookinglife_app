FactoryBot.define do
  factory :food_share do
    association :user
    association :food_record
    food_name { "food" }
    limit_number { 3 }
    limit_time { Time.zone.now + 24 * 3600 }
    give_time { Time.zone.now + 48 * 3600 }
    memo { "memo" }
    image { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec/fixtures/test-image1.jpg')) }
  end

  factory :food_share_other, class: FoodShare do
    association :user
    association :food_record
    food_name { "food" }
    limit_number { 3 }
    limit_time { Time.zone.now + 24 * 3600 }
    give_time { Time.zone.now + 48 * 3600 }
    memo { "memo_other" }
    image { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec/fixtures/test-image2.jpg')) }
  end
end
