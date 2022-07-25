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


100.times do
  name = Faker::Book.unique.title
  description = Faker::Lorem.sentence(word_count: 50)
  price = Faker::Commerce.price(range: 1..100.0)
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

10.times do |n|
  name = Faker::Name.unique.name
  phone_num = Faker::PhoneNumber.unique.phone_number
  address = Faker::Address.full_address
  total_money = Faker::Number.between(from: 50, to: 1000)
  status = Faker::Number.between(from: 0, to: 3)
  reason = Faker::Lorem.paragraph

  Order.create!(
    name: User.find(2).name,
    phone_num: phone_num,
    address: address,
    total_money: total_money,
    status: status,
    reason: reason,
    user_id: User.all.pluck(:id).sample
  )
end

50.times do |n|
  name = Faker::Name.unique.name
  phone_num = Faker::PhoneNumber.unique.phone_number
  address = Faker::Address.full_address
  total_money = Faker::Number.between(from: 50, to: 1000)
  status = Faker::Number.between(from: 0, to: 3)
  reason = Faker::Lorem.paragraph

  Order.create!(
    name: name,
    phone_num: phone_num,
    address: address,
    total_money: total_money,
    status: status,
    reason: reason,
    user_id: 2
  )
end

100.times do |n|
  price = Faker::Commerce.price(range: 1..100.0)
  quantity = Faker::Number.between(from: 1, to: 5)
  total_money = price * quantity

  OrderDetail.create!(
    price: price,
    quantity: quantity,
    total_money: total_money,
    book_id: Book.all.pluck(:id).sample,
    order_id: Order.all.pluck(:id).sample
  )
end
