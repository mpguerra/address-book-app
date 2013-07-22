namespace :db do
  desc "Fill database with sample data"
    desc "Fill database with sample data"
  task populate: :environment do
    admin2 = User.create!(name: "Ivan Kelly",
                         email: "ivan@ivankelly.net",
                         password: "foobartxt",
                         password_confirmation: "foobartxt",
                         admin: true)
  end
  task populate: :environment do
    User.create!(name: "Example User",
                 email: "example@railstutorial.org",
                 password: "foobartxt",
                 password_confirmation: "foobartxt")
    99.times do |n|
      name  = Faker::Name.name
      email = "example-#{n+1}@railstutorial.org"
      password  = "password"
      User.create!(name: name,
                   email: email,
                   password: password,
                   password_confirmation: password)
    end
      users = User.all(limit: 6)
    50.times do
      name = Faker::Name.name
      phone = Faker::PhoneNumber.phone_number
      email = Faker::Internet.email(name)
      users.each { |user| user.contacts.create!(name: name, email: email, phone: phone ) }
    end
  end
end