5.times do
  name = Faker::Book.unique.genre
  Category.create! name:name
end

5.times do
  name = Faker::Name.name
  description = Faker::Lorem.sentence
  Author.create!(name: name, description: description)
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
