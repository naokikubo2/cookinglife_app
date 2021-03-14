# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
if Rails.env.development?
  User.create!(
    name: "ゲスト",
    email: "email@guest.com",
    password: "0000guest",
    location_id: 1_850_147,
    address: '東京',
    latitude: 35.7090259,
    longitude: 139.7319925
  )

  2.upto(14) do |n|
    User.create!(
      name: "user#{n}",
      email: "email#{n}@com",
      password: n.to_s * 6,
      image: File.open("./db/fixtures/users/user#{n}.jpg"),
      location_id: 1_850_147,
      address: '東京',
      latitude: 35.7090259 + 0.001 * n,
      longitude: 139.7319925 + 0.001 * n
    )
  end
  weather = [["clear sky", "01d"], ["few clouds", "02d"]]
  1.upto(12) do |n|
    srand(n+1)
    FoodRecord.create!(
      user_id: 1,
      food_name: "food#{n}",
      image: File.open("./db/fixtures/foods/food#{n}.jpg"),
      healthy_score: rand(-3..4),
      workload_score: rand(-4..3),
      total_score: rand(1..5),
      food_date: Time.zone.today - n,
      temp: rand(1..30),
      pressure: rand(900..1000),
      humidity: rand(10..90),
      weather_main: weather[rand(0..1)][0],
      weather_icon: weather[rand(0..1)][1]
    )
  end

  # user1 は全ユーザをフォロし、他ユーザはuser1をフォロー
  2.upto(14) do |n|
    srand(n)
    Relationship.create!(
      user_id: 1,
      follow_id: n
    )
  end

  2.upto(14) do |n|
    srand(n)
    Relationship.create!(
      user_id: n,
      follow_id: 1
    )
  end
end

require "csv"

CSV.foreach('db/csv/cities.csv') do |row|
  City.create(
    name: row[0],
    location_id: row[1],
    lon: row[2],
    lat: row[3]
  )
end
