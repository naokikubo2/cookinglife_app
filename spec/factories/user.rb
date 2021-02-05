FactoryBot.define do
  factory :user do
    sequence(:name) { |i| "User#{i}" }
    sequence(:email) { |i| "email#{i}@sample.com" }
    location_id { 1_850_147 }
    address { "東京都港区" }
    password { "password" }
    latitude { 35.7090259 }
    longitude { 139.7319925 }
  end
end
