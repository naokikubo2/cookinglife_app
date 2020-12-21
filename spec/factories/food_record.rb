FactoryBot.define do
  factory :food_record do
    association :user
    food_name { "food" }
    healthy_score { 1 }
    total_score { 2 }
    workload_score { 3 }
    food_timing { "朝" }
    memo { "memo" }
    image { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec/fixtures/test-image1.jpg')) }
  end

  factory :food_record_other, class: FoodRecord do
    association :user
    food_name { "food_other" }
    healthy_score { 1 }
    total_score { 2 }
    workload_score { 3 }
    food_timing { "朝" }
    memo { "memo_other" }
    image { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec/fixtures/test-image2.jpg')) }
  end

  factory :food_record_noimage, class: FoodRecord do
    association :user
    food_name { "food_noimage" }
    healthy_score { 1 }
    total_score { 2 }
    workload_score { 3 }
    food_timing { "朝" }
    memo { "memo_noimage" }
  end
end
