# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.create(name: "Leslie Brown", email: "lkb@alum.mit.edu", password: "password", password_confirmation: "password")

Destination.create(city: "Orlando", state: "Florida", country: "United States", region: "North America")
Destination.create(city: "New York", state: "New York", country: "United States", region: "North America")
Destination.create(city: "Austin", state: "Texas", country: "United States", region: "North America")
Destination.create(city: "Bogotá", country: "Colombia", region: "South America")
Destination.create(city: "Cartagena", country: "Colombia", region: "South America")
Destination.create(city: "Lima", country: "Peru", region: "South America")
Destination.create(city: "Cuzco", country: "Peru", region: "South America")
Destination.create(city: "Buenos Aires", country: "Argentina", region: "South America")
Destination.create(city: "London", country: "England", region: "Europe")
Destination.create(city: "Cambridge", country: "England", region: "Europe")
Destination.create(city: "Budapest", country: "Hungary", region: "Europe")
Destination.create(city: "Berlin", country: "Germany", region: "Europe")
Destination.create(city: "Munich", country: "Germany", region: "Europe")