FactoryBot.define do
  factory :user do
    sequence(:name) { |i| "User#{i}" }
    sequence(:email) { |i| "email#{i}@sample.com" }
    location_id { 1850147 }
    password { "password" }
  end
end
