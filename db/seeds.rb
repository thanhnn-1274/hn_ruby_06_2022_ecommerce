5.times do
  name = Faker::Book.unique.genre
  Category.create! name:name
end

5.times do
  name = Faker::Name.name
  description = Faker::Lorem.sentence
  Author.create!(name: name, description: description)
end

User.create!(
  name: "Admin User",
  email: "admin@gmail.com",
  password: "123456",
  password_confirmation: "123456",
  role: 0,
  phone_num: "0589122355"
)


50.times do |n|
  name = Faker::Name.unique.name
  email = "test-#{n+1}@gmail.com"
  phone_num = Faker::PhoneNumber.unique.phone_number
  address = Faker::Address.full_address
  password = "password"

  User.create!(
    name: name,
    email: email,
    password: password,
    password_confirmation: password,
    address: address,
    phone_num: phone_num
  )
end


50.times do
  name = Faker::Book.unique.title
  description = Faker::Lorem.sentence(word_count: 50)
  price = Faker::Commerce.price(range: 1..100.0, as_string: true)
  publisher_name = Faker::Book.publisher
  quantity = Faker::Number.between(from: 50, to: 100)
  thumbnail = Faker::Avatar.image
  Book.create!(name: name,
               description: description,
               price: price,
               thumbnail: thumbnail,
               publisher_name: publisher_name,
               author_id: Author.all.pluck(:id).sample,
               category_id: Category.all.pluck(:id).sample,
               quantity: quantity,
               page_num: Faker::Number.between(from: 50, to: 100),
               created_at: (rand*30).days.ago
  )
end
