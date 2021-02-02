FactoryBot.define do
  factory :user do
    sequence(:name) { |i| "User#{i}" }
    sequence(:email) { |i| "email#{i}@sample.com" }
    location_id { 1_850_147 }
    address { "東京都港区" }
    password { "password" }
  end
end
