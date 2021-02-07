# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
if Rails.env.development?
  1.upto(14) do |n|
    User.create!(
      name: "user#{n}",
      email: "email#{n}@com",
      password: "#{n}" * 6,
      image:File.open("./db/fixtures/users/user#{n}.jpg"),
      location_id: 1_850_147,
      address: '東京',
      latitude: 35.7090259 + 0.0001 * n,
      longitude: 139.7319925 + 0.0001 * n
    )
  end

  1.upto(12) do |n|
    srand(n)
    FoodRecord.create!(
      user_id: 1,
      food_name: "food#{n}",
      image:File.open("./db/fixtures/foods/food#{n}.jpg"),
      healthy_score: rand(-3..4),
      workload_score: rand(-4..3),
      total_score: rand(1..5),
      food_date: Time.zone.today - n
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
