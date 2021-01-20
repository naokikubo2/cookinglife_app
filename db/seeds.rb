# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
if Rails.env.development?
  User.create(name: 'a', email: 'a@a', password: 'aaaaaa', location_id: 1850147)
  User.create(name: 'b', email: 'b@b', password: 'bbbbbb', location_id: 1850147)
  User.create(name: 'c', email: 'c@c', password: 'cccccc', location_id: 1850147)
  User.create(name: 'd', email: 'd@d', password: 'dddddd', location_id: 1850147)
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
