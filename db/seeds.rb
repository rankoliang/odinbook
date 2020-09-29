# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

100.times do
  name = Faker::Name.unique.name
  email = Faker::Internet.email(name: name, separators: '_')
  password = Devise.friendly_token.first(16)

  user = User.new(
    name: name,
    email: email,
    password: password,
    password_confirmation: password,
    summary: Faker.sentences(number: rand(4..6)).join(' ')
  )

  user.skip_confirmation!

  user.save
end
