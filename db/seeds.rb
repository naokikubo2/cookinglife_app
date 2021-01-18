# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
if Rails.env.development?
  User.create(name: 'a', email: 'a@a', password: 'aaaaaa', prefecture: 'Tokyo')
  User.create(name: 'b', email: 'b@b', password: 'bbbbbb', prefecture: 'Tokyo')
  User.create(name: 'c', email: 'c@c', password: 'cccccc', prefecture: 'Tokyo')
  User.create(name: 'd', email: 'd@d', password: 'dddddd', prefecture: 'Tokyo')
end
