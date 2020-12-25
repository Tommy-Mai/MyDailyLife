# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).

# Examples:

#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

SeedFu.seed

test_user = User.find(1)
test_user.image_name.attach(io: File.open(Rails.root.join('app', 'assets', 'images', 'icon_penguin.jpg')), filename: 'icon_penguin.jpg', content_type: 'image/jpg')
admin_user = User.find(2)
admin_user.image_name.attach(io: File.open(Rails.root.join('app', 'assets', 'images', 'icon_penguin.jpg')), filename: 'icon_penguin.jpg', content_type: 'image/jpg')
