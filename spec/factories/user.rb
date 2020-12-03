FactoryBot.define do
  factory :user do
    sequence(:name) {|i| "User#{i}" }
    sequence(:email) {|i| "email#{i}@sample.com" }
    password { "password" }
  end
end
