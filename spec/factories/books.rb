require "faker"

FactoryBot.define do
  factory :book do |f|
    f.name {Faker::Book.title}
    f.description {Faker::Lorem.sentence(word_count: 50)}
    f.price {Faker::Commerce.price(range: 1..100.0)}
    f.publisher_name {Faker::Book.publisher}
    f.quantity {Faker::Number.between(from: 50, to: 100)}
    f.thumbnail {Faker::Avatar.image}
    f.page_num {Faker::Number.between(from: 50, to: 100)}
    category {FactoryBot.create :category}
    author {FactoryBot.create :author}
    f.category_id {category.id}
    f.author_id {author.id}
  end
end
