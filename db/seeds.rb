# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'open-uri'

def generate_profile_picture
  image_link = UiFaces.face
  OpenStruct.new(
    io: URI.open(image_link),
    ext: File.extname(image_link)
  )
end

def attach_profile_picture(user)
  picture = generate_profile_picture
  file_base_tokens = user.name.scan(/\w+/) + ['ui_faces']
  file_base_name = file_base_tokens.join('_')
  filename = file_base_name + picture.ext

  user.avatar.attach(io: picture.io, filename: filename)
end

30.times do
  name = Faker::Name.unique.name
  email = Faker::Internet.email(name: name, separators: '_')
  password = Devise.friendly_token.first(16)

  user = User.new(
    name: name,
    email: email,
    password: password,
    password_confirmation: password,
    summary: Faker::Lorem.sentences(number: rand(4..6)).join(' ')
  )

  user.skip_confirmation!

  attach_profile_picture user if user.save
rescue OpenURI::HTTPError
  puts 'User skipped'
end
