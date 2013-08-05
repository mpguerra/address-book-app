namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    admin1 = User.create!(name: "Pili Guerra",
                         username: "mpguerra",
                         email: "pili@piliguerra.com",
                         password: "foobartxt",
                         password_confirmation: "foobartxt",
                         admin: true)
    admin2 = User.create!(name: "Ivan Kelly",
                         username: "ibkelly",
                         email: "ivan@ivankelly.net",
                         password: "foobartxt",
                         password_confirmation: "foobartxt",
                         admin: true)
  end
  task populate: :environment do
    User.create!(name: "Example User",
                 username: "railstut",
                 email: "example@railstutorial.org",
                 password: "foobartxt",
                 password_confirmation: "foobartxt")
    99.times do |n|
      name  = Faker::Name.name
      username = "railstut#{n+1}"
      email = "example-#{n+1}@railstutorial.org"
      password  = "password"
      User.create!(name: name,
                   username: username,
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