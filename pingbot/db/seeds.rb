# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

org = Organization.create(name: "Default Org")

user = org.users.create(name: "My User", email: "test@example.com", title: "Senior User")

ping = org.pings.create(name: "First Ping", description: "This is our first ping")

puts "Organization: #{org.inspect}"
puts "User: #{user.inspect}"
puts "Ping: #{ping.inspect}"
