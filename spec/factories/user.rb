FactoryBot.define do
  factory :user do
    sequence(:name) { |i| "User#{i}" }
    sequence(:email) { |i| "email#{i}@sample.com" }
    prefecture { "Tokyo" }
    password { "password" }
  end
end
