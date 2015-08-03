# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.create(name: "Leslie Brown", email: "lkb@alum.mit.edu", password: "password", password_confirmation: "password")

destinations = JSON.parse File.read "db/destinations_test.json"

destinations.each do |destination|
  Destination.create(destination)
end
